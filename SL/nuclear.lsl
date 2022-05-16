float NuclearFuel = 0.05;
float MaxOutput = 55.00;
float SafeMax = 35.00;
float FusionLevel = 1.0;
integer FusionRate = 5;
float TickRate = 2;
float smallTick = 0;

float difference = 0;
float outbound = 0; 


integer FusionStatus = 2; 
string FusionMsg = "System Starting";

string url = "";

float Degrigation = .000001;

float CurrentLoad = 0;
integer circut = 1;


float rods = 5;
float outgoingLoad = 0;


integer northTerm = 0;
integer southTerm = 0;

integer eastTerm = 0;
integer westTerm = 0;

integer posTerm = 0;
integer negTerm = 0;




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
       llSetText(FusionMsg, (vector)powercolor, 1);

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
                llOwnerSay("Circut Connected by internet "+body);
                llHTTPResponse(id,200,(string)FusionLevel);
                }
                
            else if (body == "circut=0"){     ///Turns off the circut
                circut = 0;
                llOwnerSay("Circut Closed by internet");
                llHTTPResponse(id,200,(string)FusionLevel);
                }  
            else if (body == "rods=plus"){    ///Increase the Load
                rods = (integer)rods + 5;
                llOwnerSay("Load raised by 5, remotely");
                llHTTPResponse(id,200,"Thank you."+FusionMsg+" Rods level: "+(string)rods);
                }  
                
            else if (body == "rods=minus"){   ///Decrease the Load

                rods = (integer)rods - 5;
                llOwnerSay("Load Lowered by 5, remotely");
                llHTTPResponse(id,200,"Thank you."+FusionMsg+" Rods level: "+(string)rods);
                } 
                
            else if (body == "info=get"){     ///Sends info to the site
                string sFusionLevel = (string)FusionLevel;
                llHTTPResponse(id,200,sFusionLevel);
                } 
            else if (body == "mode=0"){     ///Sends info to the site
                string sFusionLevel = (string)FusionLevel;
                llHTTPResponse(id,200,sFusionLevel);
                FusionStatus = 0;                
                }             
            else if (body == "mode=1"){     ///Sends info to the site
                string sFusionLevel = (string)FusionLevel;
                llHTTPResponse(id,200,sFusionLevel);
                FusionStatus = 1;
                }            
            else if (body == "mode=2"){     ///Sends info to the site
                string sFusionLevel = (string)FusionLevel;
                llHTTPResponse(id,200,sFusionLevel);
                FusionStatus = 2;
                }    
            else {

                llHTTPResponse(id,200,url);
                
                }       
            }
           } 
            
            
timer(){ 

///llOwnerSay("Tick");

      
      
if (circut == 0) {
    outgoingLoad = 0;
    FusionMsg = "circut closed";
    llRegionSay(-9009,"");
    }
    
else if (circut == 1) {

    if (FusionRate < 0){
        FusionRate = 0;
        }


    if (FusionLevel > SafeMax){
     
     float unsafe = llFrand(500);
     if (unsafe <5){
         llOwnerSay("The Reactor just melted down. There is no animation or anthing yet");
         }} 
         
if (rods >= 0){
    
    FusionLevel = FusionLevel - llFrand((float)FusionRate);
         
    }
if (FusionStatus == 2) {
        FusionMsg =  "Fusion is Occuring";
        powercolor = (vector)COLOR_GREEN;
        if (FusionLevel <= -1) {
             FusionLevel = 0;
            }
            else if (FusionLevel >= MaxOutput) {
            FusionLevel = FusionLevel - llFrand((float)FusionRate);
            NuclearFuel = NuclearFuel - llFrand(Degrigation);
            }  

        
}
if (FusionStatus == 2) { 

    if (rods > 0 ) {
            FusionLevel = FusionLevel + llFrand((float)FusionRate);
            NuclearFuel = NuclearFuel - llFrand(Degrigation);
            integer lastload = (integer)FusionLevel;
            outgoingLoad = FusionRate * lastload;  
            llOwnerSay((string)outgoingLoad); 
            llRegionSay(-9789,(string)outgoingLoad);
            outgoingLoad = 0;
            }
    else if (rods = 0) {
        if (FusionLevel >= 0 ) {
            FusionLevel = FusionLevel - llFrand((float)FusionRate);
            NuclearFuel = NuclearFuel - llFrand(Degrigation);
            integer lastload = (integer)FusionLevel;
            outgoingLoad = FusionRate * lastload;  
            llOwnerSay((string)outgoingLoad); 
            llRegionSay(-9763,(string)outgoingLoad);
            outgoingLoad = 0;
            }}}
            
            
            integer lastload = (integer)FusionLevel;
            outgoingLoad = FusionRate * lastload;              
            
llSetText("Fusion Level: "+(string)FusionLevel+
"\nPhysical Max: "+(string)MaxOutput+
"\nSafe Max: "+(string)SafeMax+
"\n \nStatus "+FusionMsg+
"\n \nFuel: "+(string)NuclearFuel+
"\n \nPower Out: "+
(string)lastload, (vector)powercolor, 1);
    }
   }
}
