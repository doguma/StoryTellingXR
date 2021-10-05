using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateGhost : MonoBehaviour
{


    public GameObject[] ghostMeshes;
    int activeMesh;

    public int framesBetweenSwap;
    int framesLeft;

    public bool animate;

    // Start is called before the first frame update
    void Start()
    {
        activeMesh = 0;
        framesLeft = framesBetweenSwap;


        foreach (GameObject mesh in ghostMeshes)
            mesh.SetActive(false);

        ghostMeshes[activeMesh].SetActive(true);

    }

    // Update is called once per frame
    void Update()
    {
        
        if (animate)
        {

            if (framesLeft < 0)
            {
                if (activeMesh + 1 < ghostMeshes.Length)
                {

                    ghostMeshes[activeMesh].SetActive(false);
                    activeMesh++;
                    ghostMeshes[activeMesh].SetActive(true);

                }
                else
                {

                    ghostMeshes[activeMesh].SetActive(false);
                    activeMesh = 0;
                    ghostMeshes[activeMesh].SetActive(true);

                }
                framesLeft = framesBetweenSwap;

            }
            else
                framesLeft -= 1;



        }


    }
}
