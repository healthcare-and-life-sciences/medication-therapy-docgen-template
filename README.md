![](/images/ahlsbanner.png)
# A-HLS Medication Therapy Doc Gen Documentation 

## Overview

This is a package that when installed will allow customers who are using the new Medication Therapy Review objects to quickly generate a document with the details of that review. 

------

## Business Benefits:

The CMS Medication Therapy Management Program (https://www.cms.gov/Medicare/Prescription-Drug-Coverage/PrescriptionDrugCovContra/MTM) requires MTM Providers to generate a summary document to be sent to the patient after a Comprehensive Medication Review (CMR) is conducted.  CMS requires MTM Providers to adhere to the Standardized Format (https://www.cms.gov/files/zip/mtm-program-standardized-format-and-technical-instructions-v2222022.zip)for this summary document.  This accelerator, allows Health Cloud customers to:

* Leverage a pre-built MTM Document template which includes a Cover Letter, the Recommended To Do items identified by the MTM Provider during the CMR consultation, and the Patient Medication List. 
* Leverage pre-built data mappings within the template to get the needed information from the Health Cloud data model into the document that is generated for each patient. 
* Clone this template and make changes to the template as needed.
* Leverage a pre-built method of kicking off the generation of the template directly from the Medication Therapy Review record of each patient. 



------

## Industry Focus and Workflow

### Primary Industry:

* Healthcare Insurance (Payers) / MTM Providers 

### Primary User Persona:

* Pharmacist or other qualified health professional. 

### User Workflow:

* Pharmacist (or other qualified health professional) conducts a Comprehensive Medication Review (CMR) with a patient
* After completing the CMR, the Pharmacist (or other qualified health professional), generates the MTM Summary Document from the Medication Therapy Review record of the patient. 



------

## Package Includes:

### **OmniScript (1)**

- MTMCreateDocument

### **DataRaptor (3)**

- FindTemplateIds - used to obtain the Ids of the Document Templates
- getMTMData - Used to extract all the data for the Document
- MTM - Transform used for Document Generation

### **Custom Components (1)**

- Unmanaged Package that includes the custom Apex Class required→ https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000VMOx&isdtp=p1

------

## Configuration Requirements

### Pre-Install Configuration Steps:

1. This solution requires the setup of Foundation Document Generation. 

2. 1. Please refer to this Salesforce Help article for Document Generation setup instructions: https://help.salesforce.com/s/articleView?id=ind.v_contracts_t_document_generation_overview_379872.htm&type=5
   2. To learn more about Foundation Document Generation, visit this Trailhead: https://trailhead.salesforce.com/content/learn/modules/foundation-document-generation

### Install Configuration Steps:

1. Install the [unmanaged Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000VMOx&isdtp=p1)

2. Import the MTMCreateDocument datapack from the following GitHub repository: https://github.com/healthcare-and-life-sciences/medication-therapy-docgen-template

3. Activate both of the Document Templates

4. Navigate to the **FindTemplateIDs** DataRaptor

5. 1. Click on Preview
   2. Execute the DataRaptor
   3. Copy the **first section** of response to the clipboard.  

6. Navigate to the **MTMCreateDocument** OmniScript

7. 1. In the step labeled “**setTemplateHERE**” click “**Edit Properties as JSON**” and then paste in the data from the step above in the **selectedTemplate** section. Click “**Close JSON Editor**“

8. Go back to the **FindTemplateIDs** DataRaptor

9. 1. Copy the second section of response
   2. Paste it in the **switchToSpanishTemplateHERE** step of the **MTMCreateDocument** OmniScript in the same way. 

10. Activate the **MTMCreateDocument** OmniScript.

11. From **Setup** > Object Manager, open the **MedicationTherapyResponse** Object

12. 1. Select “**Buttons, Links and Actions**”.  

    2. Create a new Button

    3. Paste the code below:

    4. `/lightning/cmp/omnistudio__vlocityLWCOmniWrapper?c__target=c:mtmCreateDocumentCreateDocumentEnglish&c__layout=lightning&c__tabIcon=custom:custom18&c__TemplateType=MicrosoftWord&c__ObjectId={!MedicationTherapyReview.Id`
    
    ![](/images/mtmimage1.png)

    5. Open the **Page Layout** for the **MedicationTherapyResponse** Object 

    6. 1. Drag the **Generate Document Button** into the **Custom Button** section
       2. Click **Save**

13. Navigate to a **Medication Therapy Review** record and select **Generate Document** from the dropdown action menu. The document should generate as expected.

------

## Included Document Template Details

![](/images/mtmimage2.png)
![](/images/mtmimage3.png)
![](/images/mtmimage4.png)
![](/images/mtmimage5.png)

------

## Assumptions:

- This solution assumes the use of the Medication Therapy Review objects and that they are enabled.

------

## Revision History

- **Revision Short Description (Month Day, Year)**

- - December 12, 2022 - Version 1.0
