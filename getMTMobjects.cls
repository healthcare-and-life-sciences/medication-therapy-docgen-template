/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 *
 *
 *
 * This class is a temporary class used to access the new MedicationTherapy Objects.
 *
 * Version 1.0
 *
 * November 2, 2022
 *
 * author: Derek Cassese - Accelerate HLS - dcassese@salesforce.com
 * code was adapted by Starter Class written by Charles McGuinness
 *
 */
global with sharing class getMTMobjects implements omnistudio.VlocityOpenInterface {
    // This is used for debugging purposes: a method can put information in this, and
    // if an exception is thrown, it will be included in the report back to the caller.

    private String lastTidbit = '';

    /*
     * Standard entrypoint for VlocityOpenInterface.
     */
    global Boolean InvokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        System.debug('In Method');
        try {
            if (methodName.equals('getMTR')) {
                findMedicationTherapyReview(methodName, input, output, options);
                return true;
            }
        } catch (Exception e) {
            output.put('Error', e.getMessage());
            output.put('ErrorLine', e.getLineNumber());
            output.put('TidBit', lastTidbit);
            output.put('Method', methodName);
        }
        return false;
    }

    /* This is the main function where we call the various objects we need for the document generation that are not yet available to Data Raptures due to the n-1 restriction */

    private void findMedicationTherapyReview(
        String methodName,
        Map<String, Object> input,
        Map<String, Object> output,
        Map<String, Object> options
    ) {
        String errorMessage = '';
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        String TherapyId = (String) options.get('MTRId');
        String currentCarePlanId = '';

        List<MedicationTherapyReview> MTRListNew = [
            SELECT PatientId, CareProgramId, ReviewEndDateTime, ConductedById, Name
            FROM MedicationTherapyReview
            WHERE Id = :TherapyId
        ];
        System.debug('TherapyId ' + TherapyId);
        System.debug('MTRList ' + MTRListNew.size());

        output.put('PatientId', MTRListNew[0].PatientId);
        output.put('ReviewEndDateTime', MTRListNew[0].ReviewEndDateTime);
        output.put('ConductedById', MTRListNew[0].ConductedById);
        output.put('CareProgramId', MTRListNew[0].CareProgramId);

        List<CarePlan> CarePlanListNew = [
            SELECT Description, ParticipantId, StartDate, EndDate, Status, Id
            FROM CarePlan
            WHERE MedicationTherapyReviewId = :TherapyId
        ];
        System.debug('Description ' + CarePlanListNew[0].Description);

        List<Object> CarePlanList = new List<Object>();

        for (Integer i = 0; i < CarePlanListNew.size(); i++) {
            List<Object> childList = new List<Object>();
            currentCarePlanId = CarePlanListNew[i].Id;
            List<Task> ToDoList = [SELECT Subject FROM Task WHERE WhatId = :currentCarePlanId];
            for (Integer t = 0; t < ToDoList.size(); t++) {
                Map<string, Object> child = new Map<string, Object>();
                child.put('Subject', ToDoList[t].Subject);
                childList.add(child);
            }
            Map<string, Object> parent = new Map<string, Object>();
            parent.put('ToDos', childList);
            parent.put('CarePlanID', String.valueOf(CarePlanListNew[i].Id));
            parent.put('Description', CarePlanListNew[i].Description);
            parent.put('Participant', String.valueOf(CarePlanListNew[i].ParticipantId));
            parent.put('StartDate', String.valueOf(CarePlanListNew[i].StartDate));
            parent.put('EndDate', String.valueOf(CarePlanListNew[i].EndDate));
            parent.put('Status', CarePlanListNew[i].Status);
            CarePlanList.add(parent);
        }
        output.put('CarePlans', CarePlanList);

        List<MedicationTherapyStmtReview> mtsrList = [
            SELECT Id, MedicationStatementId
            FROM MedicationTherapyStmtReview
            WHERE MedicationTherapyReviewId = :TherapyId
        ];
        System.debug('MedicationStatementId ' + CarePlanListNew[0].Description);
        List<Object> MedList = new List<Object>();
        List<Object> childList = new List<Object>();
        for (Integer m = 0; m < mtsrList.size(); m++) {
            List<MedicationStatement> medStatementList = [
                SELECT Id, MedicationId, MedicationReasonCodeId, MedicationRequestId
                FROM MedicationStatement
                WHERE Id = :mtsrList[m].MedicationStatementId
            ];
            for (Integer q = 0; q < medStatementList.size(); q++) {
                List<Medication> medicationList = [SELECT Name FROM Medication WHERE Id = :medStatementList[q].MedicationId];
                List<PatientMedicationDosage> dosgeList = [
                    SELECT Id, PatientInstruction
                    FROM PatientMedicationDosage
                    WHERE ParentRecordId = :medStatementList[q].Id
                ];
                List<CodeSetBundle> reasonList = [SELECT Name FROM CodeSetBundle WHERE Id = :medStatementList[q].MedicationReasonCodeId];
                List<MedicationRequest> medReqList = [
                    SELECT RequesterId
                    FROM MedicationRequest
                    WHERE Id = :medStatementList[q].MedicationRequestId
                ];

                for (Integer z = 0; z < medicationList.size(); z++) {
                    Map<string, Object> child = new Map<string, Object>();
                    child.put('Medication', medicationList[z].Name);
                    if (dosgeList.size() > 0) {
                        child.put('Dosge', dosgeList[0].PatientInstruction);
                    } else {
                        child.put('Dosge', '');
                    }

                    if (reasonList.size() > 0) {
                        child.put('Reason', reasonList[0].Name);
                    } else {
                        child.put('Reason', '');
                    }

                    if (medReqList.size() > 0) {
                        List<Account> requestorList = [SELECT Name FROM Account WHERE Id = :medReqList[0].RequesterId];
                        if (requestorList.size() > 0) {
                            child.put('Requestor', requestorList[0].Name);
                        } else {
                            child.put('Requestor', '');
                        }
                    }

                    childList.add(child);
                }
            }

            Map<string, Object> parent = new Map<string, Object>();
            parent.put('Medication', childList);
            MedList.add(parent);
        }
        output.put('Medications', childList);
    }
}
