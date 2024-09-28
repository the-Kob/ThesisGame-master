using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthAnimation : MonoBehaviour
{

    InterfaceManager interfaceManager;
    GameObject scorePosition;
    Coroutine coroutineHolder;
    bool go;
    Vector3 impato;
    float points;
    public bool isOrange;

    // Start is called before the first frame update
    void Start()
    {
        if(isOrange){
            scorePosition = GameObject.Find("ScoreMagnetOrange");
        }
        else{
            scorePosition = GameObject.Find("ScoreMagnetBlue");
        }
        interfaceManager = GameObject.Find("Interface").GetComponent<InterfaceManager>();
    }

    public void startAnimation(Vector3 impact){
        coroutineHolder = StartCoroutine(healthToScore(impact));
        impato = impact;
        go = true;
    }

    private void FixedUpdate() {
        if(go)
        Debug.DrawLine(transform.position, transform.position+impato);
    }

    public void setParameters(int i){
        points = i;
        this.transform.localScale = new Vector3(0.11f + i*0.03f, 0.075f, 1f);
    }

    IEnumerator healthToScore(Vector3 impact){
        Vector3 explosionPosition = Quaternion.Euler(0f, Random.Range(-15f,15f),0f) * new Vector3(transform.position.x + impact.x*Random.Range(0.5f,0.75f),transform.position.y + impact.y*Random.Range(0.5f,0.75f), transform.position.z);
        Quaternion desiredRotation = Quaternion.Euler(0f,0f, Random.Range(-90f,90f));
        float amplitude = 0f;
        float amplitudeVar = 0.001f;
        while((transform.position - explosionPosition).magnitude > 0.03f){
            transform.position = Vector3.Lerp(transform.position, explosionPosition, amplitude);
            transform.rotation = Quaternion.Slerp(transform.rotation, desiredRotation, amplitude);
            amplitude += 0.015f;
            amplitude += amplitudeVar;
            amplitudeVar -= 0.00005f;
            amplitudeVar = Mathf.Clamp(amplitudeVar, 0f, 1f);
            yield return new WaitForFixedUpdate();
        }
        
        amplitude = 0f;
        amplitudeVar = 0.001f;
        desiredRotation = Quaternion.Euler(0f,0f, Random.Range(-90f,90f));
        while((transform.position - scorePosition.transform.position).magnitude > 2f){
            transform.position = Vector3.Lerp(transform.position, scorePosition.transform.position, amplitude);
            transform.rotation = Quaternion.Slerp(transform.rotation, desiredRotation, amplitude);
            amplitude += 0.0001f;
            amplitude += amplitudeVar;
            amplitudeVar += 0.00005f;
            yield return new WaitForFixedUpdate();
        }
        interfaceManager.changeScore(points, isOrange);
        Destroy(this.gameObject);
        yield return null;
    }
}