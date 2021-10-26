
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Waypoints : MonoBehaviour
{
    public GameObject[] waypoints;
    int currentWP = 0;

    public Animator anim;
    public GameObject sittingpoint;

    public float speed = 2.0f;
    public float rotSpeed = 3.0f;

    private float curTime;
    private float pauseDuration = 1;
    private bool loop = true;

    void Start()
    {
        anim.SetBool("flying", true);
        anim.SetBool("idle", false);
    }


    void Update()
    {
        if (currentWP < 7)
        {
            patrol();

        }
        else if (currentWP < 15)
        {
            jump();
        }
        else if (currentWP < waypoints.Length)
        {
            patrol();
        }
        else
        {
            if (loop)
            {
                currentWP = 0;
            }
        }
    }

    void patrol()
    {
        anim.SetBool("jumping", false);
        anim.SetBool("idle", true);
        anim.SetBool("flying", true);
        anim.SetBool("idle", false);

        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
        {
            currentWP++;
        }
        else
        {
            Quaternion lookAtWP = Quaternion.LookRotation(target - transform.position);
            transform.rotation = Quaternion.Slerp(transform.rotation, lookAtWP, Time.deltaTime * rotSpeed);
            this.transform.Translate(0, 0, speed * Time.deltaTime);
        }
    }


    void jump()
    {
        anim.SetBool("flying", false);
        anim.SetBool("jumping", true);
        anim.SetBool("idle", false);

        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
        {
            if (curTime == 0)
            {
                anim.SetBool("jumping", false);
                anim.SetBool("idle", true);
                curTime = Time.time;
            }
            else if ((Time.time - curTime) >= pauseDuration)
            {
                anim.SetBool("jumping", true);
                anim.SetBool("idle", false);
                currentWP++;
                curTime = 0;
            }
        }
        else
        {
            Quaternion lookAtWP = Quaternion.LookRotation(target - transform.position);
            transform.rotation = Quaternion.Slerp(transform.rotation, lookAtWP, Time.deltaTime * rotSpeed);
            this.transform.Translate(0, 0, speed * Time.deltaTime);
        }
        
    }
}