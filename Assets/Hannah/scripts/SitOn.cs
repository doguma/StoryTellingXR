using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SitOn : MonoBehaviour
{
    public GameObject character;
    Animator anim;
    //bool isWalkingTowards = false;

    //void OnMouseDown()
    //{
    //    anim.SetTrigger("isWalking");
    //    isWalkingTowards = true;

    //}

    void Start()
    {
        anim = character.GetComponent<Animator>();

    }

    // Update is called once per frame
    void Update()
    {
        //if (isWalkingTowards)
        //{
        //    Vector3 targetDir;
        //    targetDir = new Vector3(transform.position.x - character.transform.position.x, 0f,
        //                            transform.position.z - character.transform.position.z);
        //    Quaternion rot = Quaternion.LookRotation(targetDir);
        //    character.transform.rotation = Quaternion.Slerp(character.transform.rotation, rot, 0.05f);
        //    character.transform.Translate(Vector3.forward * 0.01f);

        if(Vector3.Distance(character.transform.position, this.transform.position) < 2)
        {
            anim.SetBool("isSitting", true);
            anim.SetBool("isWalking", false);

            character.transform.rotation = this.transform.rotation;

                //isWalkingTowards = false;
        }
        else
        {
            anim.SetBool("isSitting", false);
            anim.SetBool("isWalking", true);
        }
    }
}

