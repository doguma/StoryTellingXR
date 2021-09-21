using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoldOn : MonoBehaviour
{

    public GameObject character;
    public GameObject pickup_parent;
    Animator anim;
    bool isWalkingTowards = false;
    bool holdingOn = false;

    private void OnMouseDown()
    {
        if (!holdingOn)
        {
            anim.SetTrigger("isWalking");
            isWalkingTowards = true;
        }
    }

    void Start()
    {
        anim = character.GetComponent<Animator>();
    }


    void Update()
    {
        if (isWalkingTowards)
        {
            Vector3 targetDir;
            targetDir = new Vector3(transform.position.x - character.transform.position.x, 0f,
                                    transform.position.z - character.transform.position.z);

            Quaternion rot = Quaternion.LookRotation(targetDir);
            character.transform.rotation = Quaternion.Slerp(character.transform.rotation, rot, 0.05f);
            character.transform.Translate(Vector3.forward * 0.01f);

            if (Vector3.Distance(character.transform.position, this.transform.position) < 0.5)
            {
                anim.SetTrigger("isHolding");
                this.transform.position = pickup_parent.transform.position;

                isWalkingTowards = false;
                holdingOn = true;
            }

            //if (anim.GetBool("hold")){
            //    this.transform.position = pickup_parent.transform.position;
            //}

        }
    }
}

