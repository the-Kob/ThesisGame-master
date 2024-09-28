using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{

    public float verticalForce = 0.05f;
    public float horizontalForce = 0.05f;

    //Variables for when enemy is hit
    private float impactTimer = 0f;
    private float maxImpactTime = 0.2f;
    private bool impacted = false;
    private float impactStrength = 0f;
    Vector3 impactVector;
    private float strength = 30f;

    void FixedUpdate()
    {

        if (impacted)
        {
            //Debug.Log(impactVector * impactTimer * impactStrength);
            transform.position = transform.position + impactVector * impactTimer * impactStrength * Time.fixedDeltaTime;
            impactTimer -= Time.fixedDeltaTime*0.75f;
        }
        else
        {
            transform.Translate(Input.GetAxis("Horizontal") * horizontalForce * 30f * Time.fixedDeltaTime, 0f, 0f);
            transform.Translate(0f, Input.GetAxis("Vertical") * verticalForce * 30f * Time.fixedDeltaTime, 0f);
        }

        if (impactTimer <= 0f)
        {
            impacted = false;
            impactVector = new Vector3(0f, 0f, 0f);
            impactStrength = 0f;
        }

        //Vector3 movement = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0f).normalized*1.2f*Time.fixedDeltaTime;
        //transform.Translate(movement);
    }

    public void getHit(Vector3 enemyPos)
    {
        impactTimer = maxImpactTime;
        impacted = true;
        impactVector = transform.position - enemyPos;
        impactVector = impactVector.normalized;
        impactStrength = strength;
    }
}