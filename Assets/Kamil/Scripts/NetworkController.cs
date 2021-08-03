using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MLAPI;
using MLAPI.Spawning;
using MLAPI.Transports.UNET;
using UnityEngine.UI;

public class NetworkController : NetworkBehaviour
{
    public Canvas canvas;
    public InputField fld_ip;

    public string ipAddr = "192.168.1.2";

    UNetTransport transport;

    public void Start()
    {
        fld_ip.text = ipAddr;
    }

    public void Host()
    {
        canvas.gameObject.SetActive(false);
        NetworkManager.Singleton.ConnectionApprovalCallback += ApprovalCheck;
        NetworkManager.Singleton.StartHost(RandomVector3(), Quaternion.identity);
    }

    private void ApprovalCheck(byte[] connection, ulong id, MLAPI.NetworkManager.ConnectionApprovedDelegate callback)
    {


        bool approve = System.Text.Encoding.ASCII.GetString(connection) == "Password";
        callback(true, null, approve, RandomVector3(), Quaternion.identity);
        
    }

    public void Join()
    {
        ipAddr = fld_ip.text;
        transport = NetworkManager.Singleton.GetComponent<UNetTransport>();
        transport.ConnectAddress = ipAddr;

        NetworkManager.Singleton.NetworkConfig.ConnectionData = System.Text.Encoding.ASCII.GetBytes("Password");
        NetworkManager.Singleton.StartClient();
        canvas.gameObject.SetActive(false);
    }


    Vector3 RandomVector3()
    {
        float x = Random.Range(-5f, 5);
        float y = -1;
        float z = Random.Range(-5f, 5);

        return new Vector3(x, y, z);
        
    }


}
