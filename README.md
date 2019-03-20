# mllpSend

swift 5 CLI streamable command sending one message HL7 using protocol TCP MLLP (not encrypted)

## syntax

   stdin > 
   
           mllpSend ip:port [charset] 
           
                                      > stdout

- returns 0 in case of successfull sending
- returns 255 in case of error detected (in which case the error is described in the stdout)

## charset

- 1 (NSASCIIStringEncoding)
- 4 (NSUTF8StringEncoding)
- 5 (NSISOLatin1StringEncoding (default, if value is omitted))
 
## stdout
- payload by mllpserver (acknoledgement or error)
- description of eventual error detected by mllpSend

## stdin data stream

- either json object which will be transformed in hl7v2 message
- or already formed hl7v2 message data
 
## json input

looks like this:


 {
 
   "Message" : "O01",
   
   "Version" : "2.3.1",
   
   "Params"  :
   
   {
   
    "sendingRisName" :                  "sendingRisName"
    
    "sendingRisIP"  :                   "sendingRisIP"
    
    ...
    
   }
   
 }
 
The elements for the json message are defined in the documentation of each of the HL7 v2 message implemented in the swift 5 library "mllp". The implementation is a proprietary specialization of the HL7 standard by opendicom.com. Being open source, the library can be adapted for other purposes.

Messages preconfigured in the library:

- A01
- A04
- O01
