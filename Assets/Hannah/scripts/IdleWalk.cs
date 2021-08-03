using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleWalk : MonoBehaviour
{
    private Animator anim;
    private float vert;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();

    }

    // Update is called once per frame
    void Update()
    {
        vert = Input.GetAxis("Vertical");
        anim.SetFloat("Walk", vert);

    }
}
