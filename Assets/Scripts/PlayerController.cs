using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{

    [SerializeField] GameObject thinkingObject;
    [SerializeField] Sprite[] effectIcons;
    [SerializeField] SpriteRenderer thinking;
    [SerializeField] WeaponHandler weaponHandler;
    [SerializeField] GameObject specialEffect;
    [SerializeField] GameObject secondaryAttack;
    [SerializeField] InterfaceManager interfaceManager;
    bool effectActive = false;
    GameObject effectObject;
    float effectCooldown = 10f;
    float effectTimer = 0f;

    float secondaryAttackCooldown = 5f;
    float secondaryAttackTimer = 0f;
    GameObject secondaryAttackObject;

    bool isInMenu = false;
    float menuCooldown;
    float deadTimer;
    bool canShoot;

    // Update is called once per frame
    void FixedUpdate()
    {

        if(deadTimer > 0f){
            deadTimer -= Time.fixedDeltaTime;
        }else if(!canShoot){
            canShoot = true;
        }

        weaponHandler.updateWeaponRotation(new Vector2(transform.position.x, transform.position.y));

        if(secondaryAttackTimer <= 0f && Input.GetButton("SecondaryAttack") && canShoot){
            secondaryAttackTimer = secondaryAttackCooldown;
            secondaryAttackObject = Instantiate(secondaryAttack, transform.position, Quaternion.identity);
            secondaryAttackObject.GetComponent<SecondaryAttackBehavior>().setEnemy("PlayerEnemy");
            interfaceManager.setAoeCooldown(secondaryAttackCooldown);
        }

        if(secondaryAttackTimer > 0f)
        {
            secondaryAttackTimer -= Time.fixedDeltaTime;
            if(secondaryAttackTimer < 0f)
            {
                secondaryAttackTimer = 0f;
            }
        }

        if(effectTimer > 0f){
            effectTimer -= Time.fixedDeltaTime;
            if(effectTimer < 0f){
                effectActive = false;
            }
        }

        if(menuCooldown > 0f){
            menuCooldown -= Time.fixedDeltaTime;
        }
    }

    void Update(){

        if (Input.GetKey("escape"))
        {
            SceneManager.LoadScene("MainMenu", LoadSceneMode.Single);
        }

        if(Input.GetButtonDown("ChooseEffect") && !effectActive && menuCooldown <= 0f){
            Time.timeScale = 0.2f;
            Time.fixedDeltaTime = Time.fixedDeltaTime * Time.timeScale;
            isInMenu = true;
            interfaceManager.openMenu();
        }
        if(Input.GetButtonUp("ChooseEffect") && isInMenu){
            Time.timeScale = interfaceManager.getTimeScale();
            Time.fixedDeltaTime = 0.02f * Time.timeScale;
            isInMenu = false;
            int effectChosen = interfaceManager.getEffectChosen();
            interfaceManager.closeMenu();
            menuCooldown = 1f;
            if(effectChosen != -1){
                effectObject = Instantiate(specialEffect, transform.position, Quaternion.identity);
                effectObject.GetComponent<PulseBehavior>().setEffect(effectChosen);
                thinkingObject.SetActive(true);
                thinking.sprite = effectIcons[effectChosen];
                StartCoroutine(thinkingAnimation());
                effectActive = true;
                effectTimer = effectCooldown;
                interfaceManager.setEffectCooldown(effectCooldown);

                GameObject tutorial = GameObject.Find("TutorialManager");
                if(tutorial != null){
                    tutorial.GetComponent<TutorialManager>().getEffect(effectChosen);
                }
            }
        }
    }
    public void setDeadTimer(float timer){
        deadTimer = timer;
        //canShoot = false;
    }

    IEnumerator thinkingAnimation(){
        yield return new WaitForSecondsRealtime(1f);
        thinkingObject.SetActive(false);
        yield return null;
    }
}