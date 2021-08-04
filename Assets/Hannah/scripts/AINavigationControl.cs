using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AINavigationControl : MonoBehaviour
{
    Animator anim;
    NavMeshAgent agent;
    Vector3 worldDeltaPosition;
    Vector2 groundDeltaPosition;
    Vector2 velocity = Vector2.zero;
    float velo_agent;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
        agent = GetComponent<NavMeshAgent>();
        agent.updatePosition = false;
    }

    // Update is called once per frame
    void Update()
    {
        worldDeltaPosition = agent.nextPosition - transform.position;
        groundDeltaPosition.x = Vector3.Dot(transform.right, worldDeltaPosition);
        groundDeltaPosition.y = Vector3.Dot(transform.forward, worldDeltaPosition);
        velocity = (Time.deltaTime > 1e-5f) ? groundDeltaPosition / Time.deltaTime : velocity = Vector2.zero;
        bool shouldMove = velocity.magnitude > 0.025f && agent.remainingDistance > agent.radius;

        velo_agent = Mathf.Abs(agent.velocity[0]) + Mathf.Abs(agent.velocity[1]) + Mathf.Abs(agent.velocity[2]);

        if (velo_agent > 0.05)
                {
            anim.SetBool("move", true);
        }
        else
        {
            anim.SetBool("move", false);
        }

    }

    private void OnAnimatorMove()
    {
        transform.position = agent.nextPosition;
    }
}
