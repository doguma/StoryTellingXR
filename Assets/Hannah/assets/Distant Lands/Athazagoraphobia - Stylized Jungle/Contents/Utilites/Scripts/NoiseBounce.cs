using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DistantLands
{
    public class NoiseBounce : MonoBehaviour
    {

        [Tooltip("Controls the strength of the noise on each axis.")]
        public Vector3 depth;
        [Tooltip("Controls the distance between peaks of the noise on each axis.")]
        public Vector3 width;
        [Tooltip("Controls the seed of the noise. Leave 0 for a random seed.")]
        public int seed;
        private Vector3 pos;



        // Start is called before the first frame update
        void Start()
        {

            if (seed == 0)
                seed = Random.Range(0, 1000000);
            pos = transform.localPosition;

        }

        // Update is called once per frame
        void Update()
        {

            float t1 = Time.time / width.x;
            float t2 = Time.time / width.y;
            float t3 = Time.time / width.z;

            Vector3 offset = new Vector3(
                (Mathf.PerlinNoise(seed, t1) - .5f) * depth.x,
                (Mathf.PerlinNoise(seed + 1000, t2) - .5f) * depth.y,
                (Mathf.PerlinNoise(seed + 2000, t3) - .5f) * depth.z);


            transform.localPosition = pos + offset;



        }
    }
}