using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LayOn : MonoBehaviour
{
    public GameObject character;
    Animator anim;

    void Start()
    {
        anim = character.GetComponent<Animator>();

    }

    // Update is called once per frame
    void Update()
    {

        if (Vector3.Distance(character.transform.position, this.transform.position) < 3)
        {
            anim.SetBool("isSleeping", true);
            anim.SetBool("isWalking", false);

            character.transform.rotation = this.transform.rotation;

        }
        if(Vector3.Distance(character.transform.position, this.transform.position) > 3)
        {
            anim.SetBool("isSleeping", false);
            anim.SetBool("isWalking", true);
        }
    }
}

