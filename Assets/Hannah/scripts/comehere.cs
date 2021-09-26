using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class comehere : MonoBehaviour
{
    public GameObject character;
    Animator anim;
    bool isWalkingTowards = false;
    bool sittingOn = false;

    private void OnMouseDown()
    {
        if (!sittingOn)
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



        }
    }
}
