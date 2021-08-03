using UnityEngine;
using UnityEngine.AI;
using System;


public class PlayerController : MonoBehaviour
{

    public Camera cam;
    public NavMeshAgent agent;

    //public Animator anim;
    public Rigidbody rigidbody1;

    private float vel;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                agent.SetDestination(hit.point);
            }
        }

        //vel = Mathf.Abs(rigidbody1.velocity[0]) + Mathf.Abs(rigidbody1.velocity[2]);      //to get a Vector3 representation of the velocity
        ////Debug.Log(rigidbody1.velocity);
        //anim.SetFloat("Walk", vel);
    }

}

// Using UnityEngine AI to find the shortest path to the destination - can be applied to traveling character