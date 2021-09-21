using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using MLAPI.SceneManagement;
using MLAPI;


using MLAPI.Spawning;
using MLAPI.Transports.UNET;
using UnityEngine.UI;
using MLAPI.Configuration;
using MLAPI.Messaging;


public class changeScene : NetworkBehaviour
{
   
    string nextScene;
    void Start()
    {

        if(SceneManager.GetActiveScene().name == "Scene 2")
        {
            nextScene = "Scene 1";
        }
        else
        {
            nextScene = "Scene 2";
        }

    }

    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (IsHost)
            {

                NetworkSceneManager.SwitchScene(nextScene);

            }

        }

    }
   
}
