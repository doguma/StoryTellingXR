
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Waypoints : MonoBehaviour
{
    public GameObject[] waypoints;
    int currentWP = 0;

    public Animator anim;
    public GameObject sittingpoint;
    public Rigidbody body;

    public float speed = 2.0f;
    public float rotSpeed = 3.0f;

    private float curTime;
    private float pauseDuration = 1;
    private bool loop = true;

    void Start()
    {
        anim.SetBool("flying", true);
        body = GetComponent<Rigidbody>();
    }


    void Update()
    {
        if (currentWP < 6)
        {
            anim.SetBool("flying", true);
            anim.SetBool("jumping", false);
            patrol();
        }
        else if (currentWP == 6)
        {
            idle();
        }
        else if (currentWP < 12)
        {
            anim.SetBool("flying", false);
            anim.SetBool("jumping", true);
            jump();
        }
        else if (currentWP == 12)
        {
            anim.SetBool("jumping", false);
            anim.SetBool("flying", true);
            idle();
        }
        else if (currentWP < waypoints.Length - 2)
        {
            anim.SetBool("jumping", false);
            anim.SetBool("flying", true);
            speed = 0.5f;
            patrol_g();
        }
        else
        {
            anim.SetBool("jumping", false);
            anim.SetBool("flying", false);
            anim.SetBool("happy", true);
            happy_idle();
        }
    }

    void idle()
    {
        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
        {
            if (curTime == 0)
            {
                anim.SetBool("jumping", false);
                anim.SetBool("flying", false);
                curTime = Time.time;
            }
            else if ((Time.time - curTime) >= 2)
            {
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

    void happy_idle()
    {
        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
        {
            if (curTime == 0)
            {
                anim.SetBool("jumping", false);
                anim.SetBool("flying", false);
                curTime = Time.time;
            }
            else if ((Time.time - curTime) >= 30)
            {
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

    void patrol()
    {

        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) >= 1)
        {
            Quaternion lookAtWP = Quaternion.LookRotation(target - transform.position);
            transform.rotation = Quaternion.Slerp(transform.rotation, lookAtWP, Time.deltaTime * rotSpeed);
            this.transform.Translate(0, 0, speed * Time.deltaTime);
        }
        else
        {
            currentWP++;
        }
    }


    void jump()
    {
        Vector3 target = waypoints[currentWP].transform.position;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
        {
            if (curTime == 0)
            {
                curTime = Time.time;
            }
            else if ((Time.time - curTime) >= 2)
            {
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

    void patrol_g()
    {

        Vector3 target = waypoints[currentWP].transform.position;
        body.useGravity = true;

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) >= 1)
        {
            Quaternion lookAtWP = Quaternion.LookRotation(target - transform.position);
            transform.rotation = Quaternion.Slerp(transform.rotation, lookAtWP, Time.deltaTime * rotSpeed);
            this.transform.Translate(0, 0, speed * Time.deltaTime);
        }
        else
        {
            currentWP++;
        }
    }
}