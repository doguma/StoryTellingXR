using UnityEngine;
using UnityEngine.AI;


public class PlayerController : MonoBehaviour
{

    public Camera cam;
    public NavMeshAgent agent;

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
    }

}

// Using UnityEngine AI to find the shortest path to the destination - can be applied to traveling character