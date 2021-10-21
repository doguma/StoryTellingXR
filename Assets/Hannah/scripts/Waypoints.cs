
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Waypoints : MonoBehaviour
{

    IEnumerator IdleTime()
    {
        yield return new WaitForSeconds(5);
    }

    public GameObject[] waypoints;
    int currentWP = 0;

    public Animator anim;
    public GameObject sittingpoint;

    public float speed = 2.0f;
    public float rotSpeed = 3.0f;

    private float curTime;
    private float pauseDuration = 3;

    // Start is called before the first frame update
    void Start()
    {
        anim.SetBool("flying", true);
    }

    // Update is called once per frame
    void Update()
    {

        if (Vector3.Distance(this.transform.position, waypoints[currentWP].transform.position) < 1)
            currentWP++;

        if (currentWP >= waypoints.Length)
            currentWP = 0;

        if (curTime == 0)
        {
            curTime = Time.time; // Pause over the Waypoint
            if ((Time.time - curTime) >= pauseDuration)
            {
                curTime = 0;
            }

            if (currentWP >= 6 && currentWP < 12)
            {

                anim.SetBool("flying", false);
                anim.SetBool("jumping", true);
            }
            else if (currentWP >= 12)
            {
                anim.SetBool("flying", true);
                anim.SetBool("jumping", false);
            }
        }
        else
        {
            Quaternion lookatWP = Quaternion.LookRotation(waypoints[currentWP].transform.position - this.transform.position);

            this.transform.rotation = Quaternion.Slerp(this.transform.rotation, lookatWP, rotSpeed * Time.deltaTime);

            this.transform.Translate(0, 0, speed * Time.deltaTime);

        }
    }
}
