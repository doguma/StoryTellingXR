using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class randomColor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        GetComponent<Renderer>().material.color = new Color(Random.Range(0.0f,1.0f), Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f)); 

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
