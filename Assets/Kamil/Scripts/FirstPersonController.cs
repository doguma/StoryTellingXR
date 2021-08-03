using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MLAPI;
using MLAPI.Messaging;
using MLAPI.Connection;

[RequireComponent(typeof(CharacterController))]
public class FirstPersonController : NetworkBehaviour
{
    bool doLog = true;

    float yVelocity = 0f;
    [Range(5f, 25f)]
    public float gravity = 15f;
    [Range(5f, 15f)]
    public float movementSpeed = 10f;
    [Range(5f, 15f)]
    public float jumpSpeed = 10f;

    Transform cameraTransform;
    Camera playerCamera;
    float pitch = 0f;
    [Range(1f, 90f)]
    public float maxPitch = 85f;
    [Range(-1f, -90f)]
    public float minPitch = -85f;
    [Range(0.5f, 5f)]
    public float mouseSensitivity = 2f;

    public float dragSpeed = 5;

    bool holdingItem = false;
    Transform heldItem = null;
    Transform heldItemParent = null;

    public GameObject networkCube;

    CharacterController cc;

    ulong clientID;

    private void Start()
    {
        clientID = NetworkManager.Singleton.LocalClientId;

        playerCamera = GetComponentInChildren<Camera>();
        cameraTransform = playerCamera.transform;


        if (IsLocalPlayer)
        {
            cc = GetComponent<CharacterController>();

        }
        else
        {
            cameraTransform.gameObject.SetActive(false);

        }
    }

    void Update()
    {
        if (IsLocalPlayer)
        {
            Look();
            Move();

            Ray ray = playerCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            Debug.DrawRay(ray.origin, ray.direction * 1, Color.yellow);

            if (Input.GetKeyUp("e"))
            {
                Log("Got e");
                
                if (holdingItem)
                {
                    DropItem();
                    Log("Holding item, dropping");
                    holdingItem = false;
                    heldItem = null;
                    

                }
                if (Physics.Raycast(ray, out hit))
                {
                    Log("did raycast");

                    Transform objHit = hit.transform;

                    Log("hit " + objHit);
                    if (objHit.tag == "movable")
                    {
                        Log("obj was movable");
                        holdingItem = true;
                        heldItem = objHit;
                        PickUp(heldItem);

                    }
                    else
                    {
                        Log("obj not movable");
                    }

                }
            }
            else if (Input.GetKeyUp("r"))
            {
                if (Physics.Raycast(ray, out hit, 100.0f))
                {
                    spawnCubeServerRpc(hit.point);
                }
            }


        }

        
        void PickUp(Transform t)
        {
            NetworkObject tnet = t.GetComponent<NetworkObject>();


            if(!tnet.IsOwner)
            {
                ServerRPCTakeOwnerServerRpc(tnet.NetworkObjectId, clientID);
                //tnet.ChangeOwnership(this.OwnerClientId);
            }

            Log(t.parent);
            heldItemParent = t.parent;
            t.SetParent(cameraTransform);
            print("held parent is " + heldItemParent);
        }
        void DropItem()
        {
            heldItem.SetParent(heldItemParent);
            heldItemParent = null;
        }


        void Look()
        {
            float xInput = Input.GetAxis("Mouse X") * mouseSensitivity;
            float yInput = Input.GetAxis("Mouse Y") * mouseSensitivity;
            transform.Rotate(0, xInput, 0);
            pitch -= yInput;
            pitch = Mathf.Clamp(pitch, minPitch, maxPitch);
            Quaternion rot = Quaternion.Euler(pitch, 0, 0);
            cameraTransform.localRotation = rot;
        }

        void Move()
        {
            Vector3 input = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            input = Vector3.ClampMagnitude(input, 1f);
            Vector3 move = transform.TransformVector(input) * movementSpeed;
            if (cc.isGrounded)
            {
                yVelocity = -gravity * Time.deltaTime;
                //check for jump here
                if (Input.GetButtonDown("Jump"))
                {
                    yVelocity = jumpSpeed;
                }
            }
            yVelocity -= gravity * Time.deltaTime;
            move.y = yVelocity;
            cc.Move(move * Time.deltaTime);
        }



    }



    [ServerRpc]
    public void ServerRPCTakeOwnerServerRpc(ulong networkID,  ulong ownerID)
    {
        Log("Holy fuck please work");
        foreach(GameObject i in (GameObject.FindGameObjectsWithTag("movable")))
        {
            NetworkObject iNet = i.GetComponent<NetworkObject>();
            if (iNet.NetworkObjectId == networkID)
            {
                iNet.ChangeOwnership(ownerID);
            }

        }

    }

    [ServerRpc]
    public void spawnCubeServerRpc(Vector3 pos)
    {
        GameObject go = Instantiate(networkCube, pos, Quaternion.identity);
        go.GetComponent<NetworkObject>().Spawn();
    }

    void Log(object msg)
    {
        if (doLog)
        {
            Debug.Log(msg);
        }
    }
}
