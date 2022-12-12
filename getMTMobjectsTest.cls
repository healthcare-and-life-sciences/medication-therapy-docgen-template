/**
 * Created by jjanarthanan on 11/22/22.
 */

@IsTest
private class getMTMobjectsTest {
    @IsTest
    static void invokeMethodTest() {
        getMTMobjects invokeObj = new getMTMobjects();

        Map<String,Object> input = new Map<String, Object>();
        Map<String,Object> output = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();

        try {
            User user = [SELECT Id FROM User LIMIT 1];

            Account patient = new Account();
            patient.Name = 'Tom';
            insert patient;

            CareProgram careProgram = new CareProgram();
            careProgram.Name = 'Sample';
            insert careProgram;

            MedicationTherapyReview medicationTherapyReview = new MedicationTherapyReview();
            medicationTherapyReview.PatientId = patient.Id;
            medicationTherapyReview.CareProgramId = careProgram.Id;
            medicationTherapyReview.ConductedById = user.Id;
            medicationTherapyReview.ReviewEndDateTime = DateTime.newInstance(2022, 12, 31, 23, 59, 59);
            insert medicationTherapyReview;

            options.put('MTRId',medicationTherapyReview.Id);

            Case caseOne = new Case();
            insert caseOne;

            CarePlan carePlan = new CarePlan();
            carePlan.Name = 'Demo';
            carePlan.CaseId = caseOne.Id;
            carePlan.Description = 'Demo';
            carePlan.ParticipantId = patient.Id;
            carePlan.StartDate = Date.today();
            carePlan.EndDate = Date.today().addDays(1);
            carePlan.Status = 'Demo';
            carePlan.MedicationTherapyReviewId = medicationTherapyReview.Id;
            insert carePlan;

            Task task = new Task();
            task.WhatId = carePlan.Id;
            insert task;

            Medication medication = new Medication();
            medication.Name = 'MedName';
            insert medication;

            MedicationStatement medicationStatement = new MedicationStatement();
            medicationStatement.PatientId = patient.Id;
            medicationStatement.MedicationId = medication.Id;
            insert medicationStatement;

            MedicationTherapyStmtReview medicationTherapyStmtReview = new MedicationTherapyStmtReview();
            medicationTherapyStmtReview.MedicationTherapyReviewId = medicationTherapyReview.Id;
            medicationTherapyStmtReview.MedicationStatementId = medicationStatement.Id;
            medicationTherapyStmtReview.Status = 'Pending';
            insert medicationTherapyStmtReview;

        } catch (DmlException e) {
            System.debug('Error1 ' + e.getStackTraceString());
            System.debug('Error2 ' + e.getMessage());
        }






        Boolean result = invokeObj.InvokeMethod('getMTR',input,output,options );
        System.debug(JSON.serialize(output));

        Assert.areEqual(result, true);
    }
}