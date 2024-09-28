using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PulseBehavior : MonoBehaviour
{

    enum effects {buffNPCEnemy, nerfNPCEnemy, buffPlayerEnemy, nerfPlayerEnemy};
    [SerializeField] effects effect;
    float pulseRadius = 0f;
    SpriteRenderer pulseSprite;
    [SerializeField] Color[] colors;
    bool effectSet;

    // Start is called before the first frame update
    void Start()
    {
        pulseSprite = gameObject.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(effectSet){
            if((int) effect == 1 || (int) effect == 3){
                if(pulseRadius < 20f){
                    pulseRadius += Time.fixedDeltaTime * 10f;
                    transform.localScale = new Vector3(pulseRadius, pulseRadius, 0);
                    Color pulseColor = pulseSprite.color;
                    pulseColor.a -= Time.fixedDeltaTime * 10f /20f;
                    pulseSprite.color = pulseColor;
                }else{
                    Destroy(this.gameObject);
                }
            }else{
                if(pulseRadius > 0){
                    pulseRadius -= Time.fixedDeltaTime * 10f;
                    transform.localScale = new Vector3(pulseRadius, pulseRadius, 0);
                    Color pulseColor = pulseSprite.color;
                    pulseColor.a += Time.fixedDeltaTime * 10f /20f;
                    pulseSprite.color = pulseColor;
                }else{
                    Destroy(this.gameObject);
                }
            }
        }
    }

    void OnTriggerExit2D(Collider2D other) {
        switch(effect){
            case effects.buffNPCEnemy:
                if(other.tag == "NPCEnemy"){
                    other.gameObject.GetComponent<EnemyBehavior>().buff();
                }
                break;
            case effects.buffPlayerEnemy:
                if(other.tag == "PlayerEnemy"){
                    other.gameObject.GetComponent<EnemyBehavior>().buff();
                }
                break;
        }
    }

    void OnTriggerEnter2D(Collider2D other) {
        
        switch(effect){
            case effects.nerfNPCEnemy:
                if(other.tag == "NPCEnemy"){
                    other.gameObject.GetComponent<EnemyBehavior>().nerf();
                }
                break;
            case effects.nerfPlayerEnemy:
            if(other.tag == "PlayerEnemy"){
                    other.gameObject.GetComponent<EnemyBehavior>().nerf();
                }
                break;
        }
    }

    internal void setEffect(int v)
    {
        effect = (effects) v;
        if(v < 2)
        this.gameObject.GetComponent<SpriteRenderer>().color = colors[1];
        else
        this.gameObject.GetComponent<SpriteRenderer>().color = colors[0];

        if(v == 0 || v == 2){
            pulseRadius = 20f;
            transform.localScale = new Vector3(pulseRadius, pulseRadius, 0);
            if(pulseSprite == null){
                pulseSprite = gameObject.GetComponent<SpriteRenderer>();
            }
            Color pulseColor = pulseSprite.color;
            pulseColor.a = 0f;
            pulseSprite.color = pulseColor;
        }
        effectSet = true;
    }
}
