package m.web;

import localhost.WsHnxUDP;
import localhost.WsHnxUDPSoap;

public class test
{
  public static void main(String[] args)
  {
    if (args.length > 0) {
      WsHnxUDP ws = new WsHnxUDP();
      WsHnxUDPSoap client = ws.getWsHnxUDPSoap12();
      //System.out.println(client);
      
      System.out.print(client.getHnxUDP(Long.parseLong(args[0])));
    } else {
      System.out.print("No Seq.");
    }
  }
  
}