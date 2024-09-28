using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class BulletManager : MonoBehaviour
{
    
    [SerializeField] GameObject bullet;
    [SerializeField] Transform pistol;
    float delay = 0.5f;
    float delayTimer = 0f;
    bool onCooldown = false;
    public bool canShoot = true;
    float deadTimer;

    // Start is called before the first frame update
    void Start()
    {
        pistol = GameObject.Find("Weapon").GetComponent<Transform>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {

        if(deadTimer > 0f){
            deadTimer -= Time.fixedDeltaTime;
        }else if(!canShoot){
            canShoot = true;
        }

        if((Input.GetAxis("FireNew") > 0.1f || Input.GetButton("Fire")) && !onCooldown && canShoot){
            AudioManagerScript audio = GameObject.Find("AudioManager").GetComponent<AudioManagerScript>();
            audio.playBulletSound();
            onCooldown = true;
            Instantiate(bullet, pistol.position, pistol.rotation);
            delayTimer = delay;
        }

        if(delayTimer > 0.0f){
            delayTimer -= Time.fixedDeltaTime;
        }

        if(delayTimer <= 0.0f){
            onCooldown = false;
        }
    }

    public void setDeadTimer(float timer){
        deadTimer = timer;
        //canShoot = false;
    }
}