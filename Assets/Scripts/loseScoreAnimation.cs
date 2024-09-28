using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class loseScoreAnimation : MonoBehaviour
{

    GameObject scorePosition;
     Vector3 explosionPosition;
    Quaternion desiredRotation;
    Vector3 posHolder;
    float amplitude;
    float amplitudeVar;

    // Start is called before the first frame update
    void Start()
    {
        explosionPosition = Quaternion.Euler(0f, 0f, Random.Range(0f,360f)) * new Vector3(Random.Range(0.25f,0.75f),Random.Range(0.25f,0.75f), transform.position.z);
        desiredRotation = Quaternion.Euler(0f,0f, Random.Range(-90f,90f));
        amplitude = 0f;
        amplitudeVar = 0.001f;
    }

    // Update is called once per frame
    private void FixedUpdate() {
        if(amplitude < 1f){
            posHolder = scorePosition.transform.position;
            transform.position = Vector3.Lerp(posHolder, posHolder + explosionPosition, amplitude);
            transform.rotation = Quaternion.Slerp(transform.rotation, desiredRotation, amplitude);
            amplitude += 0.04f;
            amplitude += amplitudeVar;
            amplitudeVar -= 0.00005f;
            amplitudeVar = Mathf.Clamp(amplitudeVar, 0f, 1f);
            amplitude = Mathf.Clamp(amplitude, 0f, 1f);
        }else{
            Destroy(this.gameObject);
        }
    }

    public void setScoreposition(GameObject scorepos){
        scorePosition = scorepos;
    }
}