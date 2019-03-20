import Foundation
import mllp

var returnValue: Int32 = -1
var encoding = String.Encoding.isoLatin1
switch CommandLine.argc {
case 3, 2:
    if CommandLine.argc == 3{
        encoding = String.Encoding.init(rawValue: UInt(CommandLine.arguments[2])!)
    }
    let inputStream: Data = FileHandle.standardInput.readDataToEndOfFile()
    if inputStream.count > 0 {
        var hl7String: String?
        if (inputStream.first == 123){
            let json = try? JSONSerialization.jsonObject(with: inputStream, options: [])
            if let dictionary = json as? [String: Any]{
                if (dictionary.index(forKey: "Message") == nil || dictionary.index(forKey: "Version") == nil || dictionary.index(forKey: "Params") == nil){
                        print(#"json without "Message" name/value or "Version" or "Params" object"#)
                }else{
                    if let message = dictionary["Message"] as? String {
                        switch message{
                        case "A01":
                            if let params = dictionary["Params"] as? [String: String] {
                                hl7String = Messages.A01(
                                    admitInpatient:params["VersionID"],
                                    sendingRisName:params["sendingRisName"],
                                    sendingRisIP:params["sendingRisIP"],
                                    receivingCustodianTitle:params["receivingCustodianTitle"],
                                    receivingPacsaet:params["receivingPacsaet"],
                                    MessageControlId:params["MessageControlId"],
                                    CountryCode:params["CountryCode"],
                                    CharacterSet:encoding,
                                    PrincipalLanguage:params["PrincipalLanguage"],
                                    PatientIdentifierList:params["PatientIdentifierList"]!,
                                    PatientName:params["PatientName"]!,
                                    PatientBirthDate:params["PatientBirthDate"],
                                    PatientAdministrativeSex:params["PatientAdministrativeSex"]
                                )
                            }
                        case "A04":
                            if let params = dictionary["Params"] as? [String: String] {
                                hl7String = Messages.A04(
                                    registerPatient:params["VersionID"],
                                    sendingRisName:params["sendingRisName"],
                                    sendingRisIP:params["sendingRisIP"],
                                    receivingCustodianTitle:params["receivingCustodianTitle"],
                                    receivingPacsaet:params["receivingPacsaet"],
                                    MessageControlId:params["MessageControlId"],
                                    CountryCode:params["CountryCode"],
                                    CharacterSet:encoding,
                                    PrincipalLanguage:params["PrincipalLanguage"],
                                    PatientIdentifierList:params["PatientIdentifierList"]!,
                                    PatientName:params["PatientName"]!,
                                    PatientBirthDate:params["PatientBirthDate"],
                                    PatientAdministrativeSex:params["PatientAdministrativeSex"])
                            }
                        case "O01":
                            if let params = dictionary["Params"] as? [String: String] {
                                hl7String = Messages.O01(
                                    singleSps:params["VersionID"],
                                    sendingRisName:params["sendingRisName"],
                                    sendingRisIP:params["sendingRisIP"],
                                    receivingCustodianTitle:params["receivingCustodianTitle"],
                                    receivingPacsaet:params["receivingPacsaet"],
                                    MessageControlId:params["MessageControlId"],
                                    CountryCode:params["CountryCode"],
                                    CharacterSet:encoding,
                                    PrincipalLanguage:params["PrincipalLanguage"],
                                    PatientIdentifierList:params["PatientIdentifierList"]!,
                                    PatientName:params["PatientName"]!,
                                    MotherMaidenName:params["MotherMaidenName"],
                                    PatientBirthDate:params["PatientBirthDate"],
                                    PatientAdministrativeSex:params["PatientAdministrativeSex"],
                                    isrPatientInsuranceShortName:params["isrPatientInsuranceShortName"] ?? "",
                                    isrPlacerNumber:params["isrPlacerNumber"] ?? "",
                                    isrFillerNumber:params["isrFillerNumber"] ?? "",
                                    spsOrderStatus:params["spsOrderStatus"] ?? "",
                                    spsDateTime:params["spsDateTime"] ?? "",
                                    rpPriority:params["rpPriority"] ?? "",
                                    spsProtocolCode:params["spsProtocolCode"] ?? "",
                                    isrDangerCode:params["isrDangerCode"] ?? "",
                                    isrRelevantClinicalInfo:params["isrRelevantClinicalInfo"] ?? "",
                                    isrReferringPhysician:params["isrReferringPhysician"] ?? "",
                                    isrAccessionNumber:params["isrAccessionNumber"] ?? "",
                                    rpID:params["rpID"] ?? "",
                                    spsID:params["spsID"] ?? "",
                                    spsStationAETitle:params["spsStationAETitle"] ?? "",
                                    spsModality:params["spsModality"] ?? "",
                                    rpTransportationMode:params["rpTransportationMode"] ?? "",
                                    rpReasonForStudy:params["rpReasonForStudy"] ?? "",
                                    isrNameOfPhysiciansReadingStudy:params["isrNameOfPhysiciansReadingStudy"] ?? "",
                                    spsTechnician:params["spsTechnician"] ?? "",
                                    rpUniversalStudyCode:params["rpUniversalStudyCode"] ?? "",
                                    isrStudyInstanceUID:params["isrStudyInstanceUID"] ?? "")
                            }
                        default:
                            print("Message \(message) not implemented")
                        }
                    }
                }
            }
        }else{
            hl7String = String(data: inputStream, encoding: String.Encoding.utf8)
        }
        if(hl7String != nil){
            var ipport = CommandLine.arguments[1].components(separatedBy: ":")
            var payload: String = ""
            let send = mllp.mllpSend.send(
                to: ipport[0],
                port: ipport[1],
                message: hl7String!,
                stringEncoding: encoding,
                payload: &payload
            )
            print(payload)
            if (send){
                returnValue = 1
            }else{
                returnValue = 0
            }
        }
    }else{
        print("expected json or hl7")
    }
default:
    print("\r\n\r\nsyntax    : cat/echo json/hl7utf8\r\n                 > mllpSend ip:port [encoding (default:5)]\r\n                      > hl7payload\r\n\r\nreturns   : 0 when succes payload was received\r\n\r\nencodings : NSASCIIStringEncoding = 1\r\n            NSUTF8StringEncoding = 4\r\n            NSISOLatin1StringEncoding = 5\r\n\r\njson      : (ver message header files of mllp library)\r\n            O01\r\n            A01\r\n            A04")
}
exit(returnValue)
