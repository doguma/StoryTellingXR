using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shellmove : MonoBehaviour
{
    float speed = 1;

    // Update is called once per frame
    void Update()
    {
        //move an object along its x, y and z with a vector representing it's velocity
        this.transform.Translate(0, (speed * Time.deltaTime)/2.0f, speed * Time.deltaTime);
    }
}
