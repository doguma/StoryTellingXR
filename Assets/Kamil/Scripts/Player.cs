using MLAPI;
using MLAPI.Messaging;
using MLAPI.NetworkVariable;
using UnityEngine;

namespace HelloWorld
{
    public class Player : NetworkBehaviour
    {
        public float speed = 2f;
        public NetworkVariableVector3 Position = new NetworkVariableVector3(new NetworkVariableSettings
        {
            WritePermission = NetworkVariablePermission.ServerOnly,
            ReadPermission = NetworkVariablePermission.Everyone
        });
        public NetworkVariableColor32 Color = new NetworkVariableColor32(new NetworkVariableSettings
        {
            WritePermission = NetworkVariablePermission.ServerOnly,
            ReadPermission = NetworkVariablePermission.Everyone});

        public override void NetworkStart()
        {
            setColorServerRpc();
            Move();

        }

        public void changeColor()
        {

            if (NetworkManager.Singleton.IsServer)
            {
                Material m = new Material(Shader.Find("Specular"));
                Color.Value = new Color(
                      Random.Range(0f, 1f),
                      Random.Range(0f, 1f),
                      Random.Range(0f, 1f));
            }
            else
            {
                setColorServerRpc();
           }
}

public void Move()
        {
            if (NetworkManager.Singleton.IsServer)
            {
                var randomPosition = GetRandomPositionOnPlane();
                transform.position = randomPosition;
                Position.Value = randomPosition;
            }
            else
            {
                SubmitPositionRequestServerRpc();
            }
        }

        [ServerRpc]
        void SubmitPositionRequestServerRpc(ServerRpcParams rpcParams = default)
        {
            Position.Value = GetRandomPositionOnPlane();
        }

        [ServerRpc]
        void setColorServerRpc(ServerRpcParams rpcParams = default)
        {
            Color.Value = new Color(
                  Random.Range(0f, 1f),
                  Random.Range(0f, 1f),
                  Random.Range(0f, 1f));


        }

        static Vector3 GetRandomPositionOnPlane()
        {
            return new Vector3(Random.Range(-3f, 3f), 1f, Random.Range(-3f, 3f));
        }



        void Update()
        {


            transform.position = Position.Value;

        }
    }
}