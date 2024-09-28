using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionsManager : MonoBehaviour
{

    bool alreadyUpdated;
    bool alreadyUpdatedNPC;
    bool hitSomeone = false;
    float hitTime = 3f;
    float hitTimer = 0f;
    bool hitSomeoneNPC = false;
    float hitTimerNPC = 3f;
    [SerializeField] InterfaceManager interfaceManager;
    [SerializeField] PlayerController playerController;
    [SerializeField] BulletManager bulletManager;

    // Update is called once per frame
    void FixedUpdate()
    {
        if (hitSomeone)
        {
            hitTimer -= Time.fixedDeltaTime;
        }

        if(hitTimer <= 0f && !alreadyUpdated)
        {
            hitSomeone = false;
            if(!hitSomeoneNPC)
                interfaceManager.setScoreUnable(true);
            alreadyUpdated = true;
        }

        if (hitSomeoneNPC)
        {
            hitTimerNPC -= Time.fixedDeltaTime;
        }

        if(hitTimerNPC <= 0f && !alreadyUpdatedNPC)
        {
            hitSomeoneNPC = false;
            if(!hitSomeone)
                interfaceManager.setScoreUnable(true);
            alreadyUpdatedNPC = true;
        }
    }

    void OnTriggerEnter2D(Collider2D col)
    {
        if (col.gameObject.tag == "PlayerEnemy" && this.gameObject.tag == "Player" && !hitSomeone)
        {
            hitSomeone = true;
            alreadyUpdated = false;
            hitTimer = hitTime;
            transform.parent.gameObject.GetComponent<PlayerMovement>().getHit(col.transform.position);
            interfaceManager.addToCombo(false);
            interfaceManager.setScoreUnable(false, 0);
            playerController.setDeadTimer(hitTime);
            bulletManager.setDeadTimer(hitTime);
        }

        if((col.gameObject.tag == "NPCEnemy" && this.gameObject.tag == "NPC" && !hitSomeoneNPC))
        {
            hitSomeoneNPC = true;
            alreadyUpdatedNPC = false;
            hitTimerNPC = hitTime;
            transform.parent.gameObject.GetComponent<NPCShootManager>().getHit(col.transform.position);
            interfaceManager.addToCombo(false);
            interfaceManager.setScoreUnable(false, 1);
        }
    }
}
