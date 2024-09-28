using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPCShootManager : MonoBehaviour
{
    //Variables for Shooting
    [SerializeField] GameObject bullet;
    [SerializeField] Transform pistol;
    [SerializeField] Collider2D[] enemies;
    [SerializeField] float radius;
    [SerializeField] LayerMask mask;
    [SerializeField] Transform player;
    float delay = 0.7f;
    float delayTimer = 0f;
    bool onCooldown = false;
    bool foundEnemy;
    int bulletCounter;

    //Variables for effect
    [SerializeField] GameObject thinkingObject;
    [SerializeField] Sprite[] effectIcons;
    [SerializeField] SpriteRenderer thinking;
    int indexOfEffect;
    int[] effects = {-1,-1,-1,-1,-1};
    List<int> effectsTemplate = new List<int>{1, 2, 3, 4};
    [SerializeField] GameObject specialEffect;
    bool effectActive = false;
    GameObject effectObject;
    float effectCooldown = 10f;
    float effectTimer = 0f;
    [SerializeField] public int preferredEffect = 2;
    int effectOnHOld = -1;
    int npcEnemiesCounter = 0;
    int playerEnemiesCounter = 0;
    Vector3 playerEnemiesPosition = Vector3.zero;
    [SerializeField] float playerRadius = 6f;
    Collider2D[] playerEnemies;
    private Vector3 playerOffset = Vector3.zero;
    float randomizePositionCooldown;
    int impossibleEffect = -1;

    //Variables for when enemy is hit
    private float impactTimer = 0f;
    private float maxImpactTime = 0.2f;
    private bool impacted = false;
    private float impactStrength = 0f;
    Vector3 impactVector;
    private float strength = 0.75f;

    //Variables for secondaryAttack
    [SerializeField] GameObject secondaryAttack;
    float secondaryAttackCooldown = 5f;
    float secondaryAttackTimer = 0f;
    GameObject secondaryAttackObject;

    [SerializeField] InterfaceManager interfaceManager;

    // Start is called before the first frame update
    void Start()
    {
        pistol = GameObject.Find("NPCWeapon").GetComponent<Transform>();
        preferredEffect = GameObject.Find("Storage").GetComponent<Storage>().getTypeOfNPC();
        Debug.Log(preferredEffect);
        effectsTemplate.Remove(preferredEffect);
        shuffleEffect();
        setImpossibleEffect();
        Random.InitState(42);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        enemies = Physics2D.OverlapCircleAll(transform.position, radius, mask);
        Vector2 npcPosition = transform.position;
        randomizePositionCooldown -= Time.fixedDeltaTime;

        //Code for Shooting
        float minDistance = 9f;
        if (!onCooldown)
        {
            //Find closest enemy
            foundEnemy = false;
            Collider2D minEnemy = null;
            
            for(int i = 0; i < enemies.Length; i++)
            {
                if (enemies[i].tag == "NPCEnemy")
                {
                    if (Vector3.Distance(transform.position, enemies[i].gameObject.transform.position) < minDistance)
                    {
                        minDistance = Vector3.Distance(transform.position, enemies[i].gameObject.transform.position);
                        minEnemy = enemies[i];
                        foundEnemy = true;
                    }
                }
            }

            if (foundEnemy)
            {
                Vector2 enemyPosition = minEnemy.transform.position;
                Quaternion bulletRotation = Quaternion.identity;

                //Find rotation for bullet
                float angle = Vector2.Angle(enemyPosition - npcPosition, new Vector2(1f, 0f));

                if (transform.position.y <= enemyPosition.y)
                {
                    bulletRotation = Quaternion.Euler(0f, 0f, angle);
                    pistol.rotation = Quaternion.Euler(0f, 0f, angle);
                }
                else
                {
                    bulletRotation = Quaternion.Euler(0f, 0f, 360f - angle);
                    pistol.rotation = Quaternion.Euler(0f, 0f, 360f - angle);
                }

                AudioManagerScript audio = GameObject.Find("AudioManager").GetComponent<AudioManagerScript>();
                audio.playNpcBulletSound();

                Instantiate(bullet, pistol.position, bulletRotation);
                bulletCounter += 1;
                onCooldown = true;
                delayTimer = delay;
            }
        }

        if (delayTimer > 0.0f)
        {
            delayTimer -= Time.fixedDeltaTime;
        }

        if (delayTimer <= 0.0f)
        {
            onCooldown = false;
        }

        npcEnemiesCounter = 0;
        playerEnemiesCounter = 0;

        //Code for Movement

        Vector3 movementVector = new Vector2(0, 0);
        Vector3 playerPosition = randomizePlayerPosition(player.position);

        npcEnemiesCounter = 0;

        Vector2 newVector = Vector2.zero;
        Vector2 newVectorForPlayer = Vector2.zero;

        for (int i = 0; i < enemies.Length; i++)
        {
            if (enemies[i].tag == "NPCEnemy")
            {
                npcEnemiesCounter += 1;
                Vector2 enemyPosition = enemies[i].gameObject.transform.position;
                Vector3 npcEnemyVector = (npcPosition - enemyPosition) / Mathf.Pow(Vector3.Distance(transform.position, enemyPosition), 6f);

                //movementVector += finalVector;

                movementVector += npcEnemyVector;

                newVector += (new Vector2(player.position.x, player.position.y) - enemyPosition) / Mathf.Pow(Vector3.Distance(player.position, enemyPosition), 2f);

                /*
                Vector3 enemyPosition = enemies[i].gameObject.transform.position;
                Vector3 playerNpcVector = (playerPosition - transform.position);
                Vector3 npcEnemyVector = (transform.position - enemyPosition);

                float enemyThreat = Mathf.Pow(10/npcEnemyVector.magnitude,2f);
                float playerImportance = playerNpcVector.magnitude;

                Debug.Log(playerImportance / enemyThreat);
                */
            }
            if(enemies[i].tag == "PlayerEnemy")
            {
                Vector2 enemyPosition = enemies[i].gameObject.transform.position;
                newVectorForPlayer += (new Vector2(player.position.x, player.position.y) - enemyPosition) / Mathf.Pow(Vector3.Distance(player.position, enemyPosition), 2f);
            }
        }

        //Code for different npc positioning based on its personality

        if (preferredEffect == 0)
            playerPosition = new Vector2(player.position.x, player.position.y) - newVector.normalized * 1.5f;
        if (preferredEffect == 1)
            playerPosition = new Vector2(player.position.x, player.position.y) + newVector.normalized;
        if (preferredEffect == 2)
            playerPosition = new Vector2(player.position.x, player.position.y) + newVectorForPlayer.normalized * 1.5f;
        if (preferredEffect == 3)
            playerPosition = new Vector2(player.position.x, player.position.y) - newVectorForPlayer.normalized;

        Debug.DrawLine(player.position, playerPosition);

        Vector3 playerNpcVector = (playerPosition - transform.position) / (1 / Mathf.Pow(Vector3.Distance(transform.position, playerPosition), 2f));

        if(effectOnHOld == 0 || effectOnHOld == 1){
            if(npcEnemiesCounter > 2 + (int)bulletCounter/100){
                sendPulse(effectOnHOld);
            }
        }

        if(effectOnHOld == 2 || effectOnHOld == 3){

            playerEnemiesCounter = 0;
            playerEnemiesPosition = Vector3.zero;

            playerEnemies = Physics2D.OverlapCircleAll(transform.position, playerRadius, mask);

            for(int i = 0; i < playerEnemies.Length; i++){

                if(enemies[i].tag == "PlayerEnemy"){
                    playerEnemiesCounter += 1;
                    playerEnemiesPosition += playerEnemies[i].gameObject.transform.position;
                }
            }

            if(playerEnemiesCounter >= 2 + (int)bulletCounter/100){
                playerEnemiesPosition += 2*playerPosition;
                playerEnemiesPosition /= playerEnemiesCounter+2;
                playerNpcVector = (playerEnemiesPosition - transform.position) / (1 / Mathf.Pow(Vector3.Distance(transform.position, playerPosition), 2f));

                if(Vector3.Distance(playerEnemiesPosition, transform.position) < 0.5f){
                    sendPulse(effectOnHOld);
                }
            }

        }

        //Debug.DrawLine(transform.position, playerNpcVector);

        float enemyThreat = movementVector.magnitude;
        float playerImportance = playerNpcVector.magnitude;

        //Debug.Log(enemyThreat);

        if (movementVector.magnitude == 0f && playerNpcVector.magnitude > 3f)
        {
            movementVector = ((playerPosition - transform.position) /(1/Mathf.Pow(Vector3.Distance(transform.position, playerPosition), 6f))).normalized;
        }
        else if(movementVector.magnitude == 0f && playerNpcVector.magnitude <= 3f)
        {
            movementVector = Vector3.zero;
        }
        else
        {
            movementVector += Vector3.Slerp(movementVector, playerNpcVector, playerImportance / enemyThreat).normalized;
        }

        Vector3 movement = movementVector.normalized * 1.5f;

        transform.position += movement * Time.fixedDeltaTime;

        //Code for secondaryAttack

        if (secondaryAttackTimer <= 0f && enemyThreat > 0.33f)
        {
            secondaryAttackTimer = secondaryAttackCooldown;
            secondaryAttackObject = Instantiate(secondaryAttack, transform.position, Quaternion.identity);
            secondaryAttackObject.GetComponent<SecondaryAttackBehavior>().setEnemy("NPCEnemy");
            interfaceManager.setAoeNPCCooldown(secondaryAttackCooldown);
        }

        if (secondaryAttackTimer > 0f)
        {
            secondaryAttackTimer -= Time.fixedDeltaTime;
            if (secondaryAttackTimer < 0f)
            {
                secondaryAttackTimer = 0f;
            }
        }

        //Code for choosing pulse
        if (!effectActive && effectOnHOld == -1){
            /*
            int predominantEffect = Random.Range(0,100);
            Debug.Log(predominantEffect);
            bool isPredominant = predominantEffect < 80;

            if(isPredominant){
                effectOnHOld = preferredEffect;
            }else{
                int effect = Random.Range(0,4);
                while(effect == preferredEffect){
                    effect = Random.Range(0,4);
                }
                effectOnHOld = effect;
            }
            Debug.Log(effectOnHOld);*/
            effectOnHOld = effects[indexOfEffect];
        }

        if(effectTimer > 0f){
            effectTimer -= Time.fixedDeltaTime;
            if(effectTimer < 0f){
                effectActive = false;
            }
        }

        if (impacted)
        {
            transform.position = transform.position + impactVector * impactTimer * impactStrength;
            impactTimer -= Time.fixedDeltaTime*0.75f;
        }

        if (impactTimer <= 0f)
        {
            impacted = false;
            impactVector = new Vector3(0f, 0f, 0f);
            impactStrength = 0f;
        }
    }

    private Vector3 randomizePlayerPosition(Vector3 playerPosition)
    {
        if(randomizePositionCooldown < 0.0f){
            playerOffset = Quaternion.Euler(0f,0f,Random.Range(0,360))*new Vector3(0.75f,0.75f,0f);
            randomizePositionCooldown = 5.0f;
        }
        return playerPosition + playerOffset;
    }

    void shuffleEffect(){
        int differentEffectPos = Random.Range(0,5);
        int differentEffect = Random.Range(0, 4);
        while(differentEffect == impossibleEffect || differentEffect == preferredEffect)
        {
            differentEffect = Random.Range(0, 4);
        }
        
        effects[differentEffectPos] = differentEffect;
        for(int i = 0; i < effects.Length; i++){
            if(effects[i] == -1){
                effects[i] = preferredEffect;
            }
        }
        for(int i = 0; i < effects.Length; i++){
            Debug.Log(effects[i]);
        }
    }

    void sendPulse(int activeEffect){
        effectObject = Instantiate(specialEffect, transform.position, Quaternion.identity);
        effectObject.GetComponent<PulseBehavior>().setEffect(activeEffect);

        thinkingObject.SetActive(true);
        thinking.sprite = effectIcons[activeEffect];
        StartCoroutine(thinkingAnimation());

        effectActive = true;
        effectTimer = effectCooldown;
        effectOnHOld = -1;
        
        effects[indexOfEffect] = -1;
        indexOfEffect += 1;
        if(indexOfEffect == 5){
            indexOfEffect = 0;
            shuffleEffect();
        }

        interfaceManager.setEffectNPCCooldown(effectCooldown);
        interfaceManager.setNPCEffectIcon(activeEffect);
        
        
    }

    public void getHit(Vector3 enemyPos)
    {
        impactTimer = maxImpactTime;
        impacted = true;
        impactVector = transform.position - enemyPos;
        impactVector = impactVector.normalized;
        impactStrength = strength;
    }

    public void setImpossibleEffect()
    {
        switch (preferredEffect)
        {
            case 0:
                impossibleEffect = 1;
                break;
            case 1:
                impossibleEffect = 0;
                break;
            case 2:
                impossibleEffect = 3;
                break;
            case 3:
                impossibleEffect = 2;
                break;
        }
    }

    IEnumerator thinkingAnimation(){
        yield return new WaitForSecondsRealtime(1f);
        thinkingObject.SetActive(false);
        yield return null;
    }
}