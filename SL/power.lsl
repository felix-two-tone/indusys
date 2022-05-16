float MaxStorage = 25000000.00;
float CurrentStorage = 1.0;
integer ChargeRate = 0;
float TickRate = 1;
integer ChargeStatus = 1; //Should only be 1 ever
string ChargeMsg = "System Starting";



string url = "";

float Degrigation = 1;
float CurrentOutput = 0;
float CurrentLoad = 0;
integer circut = 0;


float loadUp = 50;

float incomingLoad = 0;
float outgoingLoad = 0;


integer northTerm = 0;
integer southTerm = 0;

integer eastTerm = 0;
integer westTerm = 0;

integer posTerm = 0;
integer negTerm = 0;

integer listen_handle;


vector COLOR_WHITE = <1.0, 1.0, 1.0>;
vector COLOR_RED = <1.000, 0.255, 0.212>;
vector COLOR_GREEN = <0.180, 0.800, 0.251>;
vector powercolor = <0.180, 0.800, 0.251>;

///SERVER STATS

key requestURL;


default
{
    state_entry()
    {
    integer intCurrentStorage = (integer)CurrentStorage;
    integer intMaxStorage = (integer)MaxStorage;
    listen_handle = llListen(-9789, "", NULL_KEY, "");
    listen_handle = llListen(-9763, "", NULL_KEY, "");
    listen_handle = llListen(-9003, "", NULL_KEY, "");
    llSetText("Charge Level: "+(string)intCurrentStorage+"\nMax Storage: "+(string)intMaxStorage+"\n \nStatus "+ChargeMsg+"\n \nRate: "+(string)ChargeRate, (vector)powercolor, 1);

    llSetTimerEvent(TickRate);

  requestURL = llRequestURL();     // Request that an URL be assigned to me.
}
  http_request(key id, string method, string body) 
     {
        if ((method == URL_REQUEST_GRANTED) && (id == requestURL) )
        {
            // An URL has been assigned to me.
            llOwnerSay("SLURL = \""+body+"\"");
            url = body;
            requestURL = NULL_KEY;
        }
        else if ((method == URL_REQUEST_DENIED) && (id == requestURL)) 
        {
            // I could not obtain a URL
            llOwnerSay("There was a problem, and an URL was not assigned: " + body);
            requestURL = NULL_KEY;
        }

        else if (method == "POST") 
        {
            ///Remote commands from python script
            if (body == "circut=1"){      ///Turns on the circut
                circut = 1;
                llSay(0,"Circut Connected by internet "+body);
                llHTTPResponse(id,200,(string)CurrentStorage);
                }
                
            else if (body == "circut=0"){     ///Turns off the circut
                circut = 0;
                llSay(0,"Circut Closed by internet");
                llHTTPResponse(id,200,(string)CurrentStorage);
                }  
            else if (body == "incomingLoad=plus"){    ///Increase the Load
                ChargeRate = ChargeRate + (integer)loadUp;
                llSay(0,"Charge Rate increased manually to: "+(string)ChargeRate);
                llHTTPResponse(id,200,"Thank you."+ChargeMsg+" Charge Rate: "+(string)ChargeRate);
                }  
                
            else if (body == "incomingLoad=minus"){   ///Decrease the Load

                ChargeRate = ChargeRate - (integer)loadUp;
                llSay(0,"Charge Rate decreased manually to: "+(string)ChargeRate);
                llHTTPResponse(id,200,"Thank you."+ChargeMsg+" Charge Rate: "+(string)ChargeRate);
                } 
                
   
            else {
               /// llSay(-93499,body);
                llHTTPResponse(id,200,"FUNCTION DEFUNCT");
                
                }       
            }
           } 
            
            

             
listen( integer channel, string name, key id, string message )
    {
        if (channel==-9789){
   
      incomingLoad = (float)message;
      outgoingLoad = 0;
      circut = 1;

    }
//        else if (channel==-9763){
        

//      incomingLoad = 0;
//      outgoingLoad = 0-(float)message;
      
       
//     }
     
             else if (channel==-9003){
             circut = 0;      
       
     }
             }
             
 timer(){ 
if (circut == 0) {
    
   ChargeRate = 0;
    
    }
    
else if (circut == 1) {
    
    if (ChargeRate < 0){

        }
    
    
    
 if (ChargeStatus == 1) {
     
 //    if (incomingLoad > outgoingLoad){
  //       ChargeMsg = "System Charging";
      
         }
//     else if (incomingLoad < outgoingLoad){
//         ChargeMsg = "System Discharging";
         
//         }
        ChargeMsg =  "System Active";
        powercolor = (vector)COLOR_GREEN;
        if (CurrentStorage <= -1) {
            CurrentStorage = 0;
            circut = 0;
            ChargeRate = 0;
            ChargeMsg = "System Disconnected";
            }
            else if (CurrentStorage >= MaxStorage) {
            CurrentStorage = MaxStorage;

            }             
            else if (CurrentStorage >= 0) {
            
            float mean = (integer)incomingLoad;
            ChargeRate = ChargeRate + (integer)mean;
            if (mean<=0){
            ChargeRate = 0;
            }
            incomingLoad = 0;
            outgoingLoad = 0;
            CurrentStorage = CurrentStorage + ChargeRate;

            
            MaxStorage = MaxStorage + llFrand(Degrigation);
            }        
}



     


        
        integer intCurrentStorage = (integer)CurrentStorage;
        integer intMaxStorage = (integer)MaxStorage;
        
        
        llSetText("Charge Level: "+(string)intCurrentStorage+"\nMax Storage: "+(string)intMaxStorage+"\n \nStatus "+ChargeMsg+"\n \nRate: "+(string)ChargeRate, (vector)powercolor, 1);
    }
   }

