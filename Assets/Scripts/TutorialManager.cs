using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class TutorialManager : MonoBehaviour
{

    [SerializeField] TextMeshProUGUI tutorialText;
    [SerializeField] GameObject enemy;
    [SerializeField] GameObject npcEnemy;
    [SerializeField] Transform player;
    [SerializeField] GameObject[] arrows;
    [SerializeField] InterfaceManager interfaceManager;
    [SerializeField] BulletManager shootManager;
    [SerializeField] Sprite npcJailSprite;
    [SerializeField] GameObject continueText;

    [SerializeField] GameObject bookTutorial;
    [SerializeField] Image bookImageTutorial;
    [SerializeField] TextMeshProUGUI bookTextTutorial;
    [SerializeField] Sprite[] images;
    [SerializeField] Image[] progressBarImages;
    [SerializeField] Sprite progressBarFull;
    int bookCounter = 0;
    [SerializeField] TextMeshProUGUI pageCounter;

    int tutorialPhase = 0;
    int lastTutorialPhase = 0;
    int enemiesAlive = 0;
    bool spawnedEnemies = false;
    bool usedDebuff = false;
    bool usedBuff = false;

    string[] phrases = {"Use left joystick to move",
                        "Use right joystick to aim",
                        "Press R1 or R2 to shoot",
                        "Kill these enemies",
                        "Use L1 to debuff your enemies",
                        "Press Square to use your secondary attack and kill these enemies",
                        "Use L1 to buff blue enemies and kill them",
                        "You can't kill them, right?",
                        "Just as we expected...",
                        "Ok, here. Read these instructions."};
    
    string[] bookPhrases = {"This book was made on the go, we do not have much time. Hopefully this explanation is enough. Handle with care. -Rufus",
                            "Our team of researchers were doing significant progress on understanding paralel universes. Doing so would bring a big new boom to science as a whole.",
                            "But, like everything in the world, people moved by greed (the rebels) were trying to get their hands onto our research. They tried so much that eventually...",
                            "They suceeded.",
                            "And like the smart people they are (were), decided to activate the prototype. Our team was the only shielded from such disaster. And, somehow, you.",
                            "And just like that, what was once one universe...",
                            "Became two.",
                            "We are here.",
                            "This is creating what we call the 'Splitters', holographic creatures who are visible in both universes",
                            "But we can only destroy the Splitters of our universe, which will not be enough",
                            "Luckily we found we can have influence on the other universe in the form of pulse forces, making those Splitters easier or harder to kill.",
                            "We were able to establish a connection with the other universe's researchers, who claim one of these 4 people might be your other universe self.",
                            "We only got you. Your job is to first understand which companion from the other universe is, indeed, yourself, and slay some Splitters together.",
                            "From what we observe, making splitters harder to kill will make them thougher, get less impact from shots, and slightly increase their movement speed.",
                            "Why would we make them harder to kill? To Sync, of course.",
                            "The more score you and your companion do, the bigger the odds of syncing both universes.",
                            "You, or your companion, can also make them easier to kill, and try to sync by comboing, as we like to call it",
                            "Killing multiple Splitters in a small period of time will create a combo, meaning each consequent kill will give more sync energy.",
                            "But be careful, getting hit while the combo is high is really damaging to the connection between both universes and you wont be able to gather energy for a while",
                            "This is just a hunch, but we do think your connection with your companion can be even more important than the sync energy we gather. Don't forget he is in another whole universe, light-years from us. If you can sync between yourselves, the universes might be able to sync as well",
                            "Wish you the best of lucks. Choose wisely."};

    // Start is called before the first frame update
    void Start()
    {
        foreach(GameObject a in arrows){
            a.SetActive(false);
        }
        Random.InitState(42);
    }

    // Update is called once per frame
    void Update()
    {
        if(tutorialText.text == "" && tutorialPhase < phrases.Length){
            tutorialText.text = phrases[tutorialPhase];
        }
        if(tutorialPhase + bookCounter == phrases.Length + bookPhrases.Length && Input.GetButtonDown("Continue"))
        {
            Time.timeScale = 1f;
            Time.fixedDeltaTime = 0.02f;
            SceneManager.LoadScene("MainMenu", LoadSceneMode.Single);
            AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
            audio.playMenuMusic();
        }
        else if(bookCounter > 0 && Input.GetButtonDown("Continue")){
            bookTextTutorial.text = bookPhrases[bookCounter];
            bookImageTutorial.sprite = images[bookCounter];
            progressBarImages[bookCounter].sprite = progressBarFull;
            bookCounter += 1;
            pageCounter.text = "Page " + bookCounter + " of " + bookPhrases.Length;
        }
        switch(tutorialPhase){
            case -1:
                break;
            case 0:
                if(Mathf.Abs(Input.GetAxis("Horizontal")) > 0.1f || Mathf.Abs(Input.GetAxis("Vertical")) > 0.1f){
                    StartCoroutine(getNextTutorialPhase());
                }
                break;
            case 1:
                if(Mathf.Abs(Input.GetAxis("MoveWeaponHorizontal")) > 0.75f || Mathf.Abs(Input.GetAxis("MoveWeaponVertical")) > 0.75f){
                    StartCoroutine(getNextTutorialPhase());
                }
                break;
            case 2:
                if(Input.GetAxis("FireNew") > 0.1f || Input.GetButton("Fire")){
                    StartCoroutine(getNextTutorialPhase());
                }
                break;
            case 3:
                if(!spawnedEnemies){
                    enemiesAlive = 5;
                    for(int i = 0; i < 5; i++){
                        Vector3 enemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(3f, 5f), Random.Range(3f, 5f), 0);
                        GameObject enemyspawned = Instantiate(enemy, player.position + enemyOffset, Quaternion.Euler(0, 0, 0));
                        enemyspawned.GetComponent<EnemyBehavior>().setTutorialFlag();
                        if(i == 1){
                            enemyspawned.GetComponent<EnemyBehavior>().buff();
                        }
                        if(i == 2){
                            enemyspawned.GetComponent<EnemyBehavior>().receiveDamage(1f,Vector3.zero,0f);
                        }
                        if(i == 3){
                            enemyspawned.GetComponent<EnemyBehavior>().receiveDamage(1f,Vector3.zero,0f);
                            enemyspawned.GetComponent<EnemyBehavior>().receiveDamage(1f,Vector3.zero,0f);
                        }
                        if(i == 4){
                            enemyspawned.GetComponent<EnemyBehavior>().nerf();
                        }
                    }
                    spawnedEnemies = true;
                }else{
                    if(enemiesAlive == 0){
                        StartCoroutine(getNextTutorialPhase());
                    }
                }
                break;
            case 4:
                if(!spawnedEnemies){
                    enemiesAlive = 5;
                    spawnedEnemies = true;
                    arrows[0].SetActive(true);
                    for (int i = 0; i < 5; i++){
                        Vector3 enemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(3f, 5f), Random.Range(3f, 5f), 0);
                        GameObject enemyspawned = Instantiate(enemy, player.position + enemyOffset, Quaternion.Euler(0, 0, 0));
                        enemyspawned.GetComponent<EnemyBehavior>().setTutorialFlag();
                    }
                }else{
                    if(usedDebuff){
                        foreach(GameObject a in arrows)
                        {
                            a.SetActive(false);
                        }
                        tutorialText.color = new Color(0f,204,0f,1f);
                        if(enemiesAlive == 0){
                            StartCoroutine(getNextTutorialPhase());
                        }
                    }else{
                        if(enemiesAlive == 0)
                            spawnedEnemies = false;
                        if (Input.GetButtonDown("ChooseEffect"))
                        {
                            StartCoroutine(showSecondArrow());
                        }
                        else if (Input.GetButtonUp("ChooseEffect"))
                        {
                            arrows[1].SetActive(false);
                            arrows[0].SetActive(true);
                        }
                    }
                }
                break;
            case 5:
                shootManager.canShoot = false;
                arrows[2].SetActive(true);
                if (!spawnedEnemies)
                {
                    enemiesAlive = 5;
                    spawnedEnemies = true;
                    arrows[2].SetActive(true);
                    for (int i = 0; i < 5; i++)
                    {
                        Vector3 enemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(3f, 5f), Random.Range(3f, 5f), 0);
                        GameObject enemyspawned = Instantiate(enemy, player.position + enemyOffset, Quaternion.Euler(0, 0, 0));
                        enemyspawned.GetComponent<EnemyBehavior>().nerf();
                        enemyspawned.GetComponent<EnemyBehavior>().setTutorialFlag();
                    }
                }
                else
                {
                    if (enemiesAlive == 0)
                    {
                        arrows[2].SetActive(false);
                        shootManager.canShoot = true;
                        StartCoroutine(getNextTutorialPhase());
                    }
                }
                break;
            case 6:
                if(!spawnedEnemies){
                    enemiesAlive = 3;
                    spawnedEnemies = true;
                    arrows[0].SetActive(true);
                    for (int i = 0; i < 3; i++){
                        Vector3 enemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(3f, 5f), Random.Range(3f, 5f), 0);
                        GameObject enemyspawned = Instantiate(enemy, player.position + enemyOffset, Quaternion.Euler(0, 0, 0));
                        enemyspawned.GetComponent<EnemyBehavior>().setTutorialFlag();
                        GameObject npcEnemyspawned = Instantiate(npcEnemy, player.position + enemyOffset, Quaternion.Euler(0, 0, 0));
                        npcEnemyspawned.GetComponent<SpriteRenderer>().sprite = npcJailSprite;
                    }
                }else{
                    if(usedBuff){
                        foreach(GameObject a in arrows)
                        {
                            a.SetActive(false);
                        }
                        if(enemiesAlive == 0){
                            StartCoroutine(getNextTutorialPhase());
                        }
                    }else{
                        if(enemiesAlive == 0)
                            spawnedEnemies = false;
                        if (Input.GetButtonDown("ChooseEffect"))
                        {
                            StartCoroutine(showFourthArrow());
                        }
                        else if (Input.GetButtonUp("ChooseEffect"))
                        {
                            arrows[3].SetActive(false);
                            arrows[0].SetActive(true);
                        }
                    }
                }
                break;
        }
        if(tutorialPhase > 6 && Input.GetButtonDown("Continue") && bookCounter < 1)
        {
            tutorialPhase = tutorialPhase + 1;
            tutorialText.text = "";
        }
        if(tutorialPhase == phrases.Length && Input.GetButtonDown("Continue") && bookCounter < 1){
            bookTutorial.SetActive(true);
            progressBarImages[bookCounter].sprite = progressBarFull;
            bookCounter = 1;
            pageCounter.text = "Page 1 of " + bookPhrases.Length;
            Time.timeScale = 0f;
            Time.fixedDeltaTime = 0f;
        }
    }

    IEnumerator getNextTutorialPhase(){
        lastTutorialPhase = tutorialPhase;
        tutorialPhase = -1;
        tutorialText.color = new Color(0f,204,0f,1f);
        Color tmp = tutorialText.color;

        while(tmp.a > 0f){
            tmp.a -= 0.01f;
            tutorialText.color = tmp;
            yield return new WaitForFixedUpdate();
        }
        tutorialText.text = "";
        tutorialText.color = new Color(255f,255f,255f,1f);
        tutorialPhase = lastTutorialPhase + 1;
        spawnedEnemies = false;
        
        if(tutorialPhase > 6){
            continueText.SetActive(true);
        }

        yield return null;
    }

    IEnumerator showSecondArrow()
    {
        yield return new WaitForFixedUpdate();
        if (interfaceManager.isMenuOpen)
        {
            arrows[1].SetActive(true);
            arrows[0].SetActive(false);
        }
        yield return null;
    }

    IEnumerator showFourthArrow()
    {
        yield return new WaitForFixedUpdate();
        if (interfaceManager.isMenuOpen)
        {
            arrows[3].SetActive(true);
            arrows[0].SetActive(false);
        }
        yield return null;
    }

    internal void decreaseEnemyCount()
    {
        enemiesAlive -= 1;
    }

    internal void getEffect(int effect){
        if(effect == 3 && tutorialPhase == 4){
            usedDebuff = true;
        }
        if(effect == 0 && tutorialPhase == 6){
            usedBuff = true;
        }
    }
}