using UnityEngine;
using MLAPI;
using MLAPI.Transports.UNET;
using UnityEngine.UI;
using MLAPI.SceneManagement;


public class NetworkController : NetworkBehaviour
{
    public Canvas canvas;
    public InputField fld_ip;

    public string ipAddr = "192.168.1.2";
    public string defaultScene = "Scene 1";
    public string defaultPassword = "Password";

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
        NetworkSceneManager.SwitchScene(defaultScene);
        
    }

    private void ApprovalCheck(byte[] connection, ulong id, MLAPI.NetworkManager.ConnectionApprovedDelegate callback)
    {


        bool approve = System.Text.Encoding.ASCII.GetString(connection) == defaultPassword;
        callback(true, null, approve, RandomVector3(), Quaternion.identity);
        
    }

    public void Join()
    {
        ipAddr = fld_ip.text;
        transport = NetworkManager.Singleton.GetComponent<UNetTransport>();
        transport.ConnectAddress = ipAddr;

        NetworkManager.Singleton.NetworkConfig.ConnectionData = System.Text.Encoding.ASCII.GetBytes(defaultPassword);
        NetworkManager.Singleton.StartClient();
        canvas.gameObject.SetActive(false);

    }

    public void ReJoin()
    {

        transport = NetworkManager.Singleton.GetComponent<UNetTransport>();
        transport.ConnectAddress = ipAddr;

        NetworkManager.Singleton.NetworkConfig.ConnectionData = System.Text.Encoding.ASCII.GetBytes(defaultPassword);
        NetworkManager.Singleton.StartClient();
    }


    Vector3 RandomVector3()
    {
        float x = Random.Range(-4f, 4);
        float y = 1;
        float z = Random.Range(-4f, 4);

        return new Vector3(x, y, z);
        
    }



}
