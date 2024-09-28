using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

public class SharedBulletBehavior : MonoBehaviour
{

    [SerializeField] float lifespan;
    [SerializeField] bool isPlayer;
    InterfaceManager interfaceManager;
    [SerializeField] GameObject bEffect;
    private float effectTimer = 0.02f;
    private Vector3 effectPos;
    private float angleEffect = 10f;

    // Start is called before the first frame update
    void Start()
    {
        interfaceManager = GameObject.Find("Interface").GetComponent<InterfaceManager>();
        effectPos = transform.position;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(lifespan < 0f){
            if(isPlayer){
                interfaceManager.saveMissPlayer();
            }else{
                interfaceManager.saveMissNPC();
            }
            Destroy(gameObject);
        }else{
            lifespan -= Time.fixedDeltaTime;
        }

        if(effectTimer < 0f){
            Instantiate(bEffect, Quaternion.Euler(0f,0f,angleEffect)*(effectPos - transform.position) + transform.position, quaternion.identity);
            effectTimer = 0.02f;
            effectPos = transform.position;
            angleEffect = -angleEffect;
        }else{
            effectTimer -= Time.fixedDeltaTime;
        }
    }
}