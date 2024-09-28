using System.Collections;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class InterfaceManager : MonoBehaviour
{

    [SerializeField] TextMeshProUGUI score;
    [SerializeField] TextMeshProUGUI scoreUnable;
    [SerializeField] GameObject finalScore;
    [SerializeField] TMPro.TextMeshProUGUI comboText;
    [SerializeField] Color[] colors;
    private int fontSize = 20;

    [SerializeField] GameObject[] interfaceButtons;
    [SerializeField] Sprite effectIconHolder;
    bool playerEffectActive;
    bool npcEffectActive;
    [SerializeField] Image effectIcon;
    [SerializeField] Image effectIconNPC;
    [SerializeField] Image[] effectIcons;
    [SerializeField] GameObject[] effectButtons;
    public bool isMenuOpen;
    public bool openOnce;
    int effectChosen = -1;
    [SerializeField] RectTransform effectCooldown;
    [SerializeField] RectTransform aoeCooldown;
    [SerializeField] RectTransform effectCooldownNPC;
    [SerializeField] RectTransform aoeCooldownNPC;
    float effectCooldownTime;
    float aoeCooldownTime;
    float effectCooldownNPCTime;
    float aoeCooldownNPCTime;
    [SerializeField] Color playerColor;
    [SerializeField] Color npcColor;
    [SerializeField] Color white;
    [SerializeField] Color startTimeColor;
    [SerializeField] Color finishTimeColor;

    [SerializeField] RectTransform orangeUniverse;
    [SerializeField] RectTransform blueUniverse;
    float scoreFloat = 0f;
    private int comboMultiplier = 0;
    private float comboTimer = 2f;
    private float activeCombo = 0.0f;
    private bool isActiveCombo = false;
    [SerializeField] GameObject lifePrefab;
    GameObject scorePositionOrange;
    GameObject scorePositionBlue;
    GameObject scorePosition;
    bool gainScore;
    [SerializeField] GameObject[] orangeStars;
    [SerializeField] GameObject[] blueStars;
    GameObject orangeUniversePos;
    GameObject blueUniversePos;

    [SerializeField] WaveManager waveManager;
    [SerializeField] Camera cameraScene;

    [SerializeField] GameObject timeFrame;
    [SerializeField] TextMeshProUGUI timeText;
    float timeSeconds = 180f;
    float minutes;
    float seconds;
    float second = 1f;
    int secondsInt = 0;
    [SerializeField] RectTransform time;
    float timeMaskSize = 320f;
    [SerializeField] GameObject[] minuteFrames;
    int frameDeleted = 0;
    Vector3 colorDelta;
    [SerializeField] GameObject timeSprite;
    Storage storage;

    public float timeScale = 1f;

    void Start() {
        scorePositionOrange = GameObject.Find("ScoreMagnetOrange");
        scorePositionBlue = GameObject.Find("ScoreMagnetBlue");
        scorePosition = GameObject.Find("ScoreMagnet");
        timeScale = 1f;
        Time.timeScale = 1f;
        Time.fixedDeltaTime = 0.02f * Time.timeScale;
        storage = GameObject.FindGameObjectWithTag("Storage").GetComponent<Storage>();

        if(timeSprite != null)
            timeSprite.gameObject.GetComponent<Image>().color = startTimeColor;
            
        colorDelta = new Vector3((startTimeColor.r - finishTimeColor.r)/timeSeconds,(startTimeColor.g - finishTimeColor.g)/timeSeconds,(startTimeColor.b - finishTimeColor.b)/timeSeconds);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(orangeUniverse != null)
        orangeUniverse.localScale = new Vector2(1f,1f);
        if(blueUniverse != null)
        blueUniverse.localScale = new Vector2(1f,1f);
        this.score.fontSize = 72f;
        //Time passing code

        if(seconds < 0f)
        {
            DisplayTime(timeSeconds);
            timeSeconds -= 1f;
            seconds = 1f;
            if(secondsInt % 30 == 0 && waveManager != null)
            {
                waveManager.startWave();
            }
            if(secondsInt % 60 == 0 && secondsInt > 0){
                timeScale += 0.1f;
                Time.timeScale = timeScale;
                Time.fixedDeltaTime = 0.02f * Time.timeScale;
                //StartCoroutine(fadeMinuteFrame(frameDeleted));
                frameDeleted += 1;
            }
            secondsInt += 1;
            if(timeText != null)
                timeText.text = (((int) timeSeconds)%60) >= 10 ? "" + (int) Mathf.Floor((timeSeconds)/60f) + ":" + ((int) timeSeconds)%60 : "" + (int) Mathf.Floor((timeSeconds)/60f) + ":0" + ((int) timeSeconds)%60;
        }
        else
        {
            seconds -= Time.fixedDeltaTime;
        }

        //Combo Code

        if (activeCombo > 0.0f)
        {
            activeCombo -= Time.fixedDeltaTime;
            comboText.color -= new Color(0f, 0f, 0f, Time.fixedDeltaTime / comboTimer);
            //comboText.rectTransform.rotation = Quaternion.Lerp(comboText.rectTransform.rotation, Quaternion.identity, Time.fixedDeltaTime);
        }
        if (activeCombo < 0.0f && isActiveCombo)
        {
            comboMultiplier = 0;
            comboText.text = "";
            isActiveCombo = false;
            for(int i = 2; i < orangeStars.Length; i++){
                orangeStars[i].SetActive(false);
                blueStars[i].SetActive(false);
            }
        }

        //Game end Code

        if(secondsInt == 180){
            finalScore.SetActive(true);
            timeFrame.SetActive(false);
            timeText.gameObject.SetActive(false);
            time.gameObject.SetActive(false);
            finalScore.GetComponent<TextMeshProUGUI>().text = "Score: " + score.text;
            timeScale = 0f;
            Time.timeScale = 0f;
            Time.fixedDeltaTime = 0.02f * Time.timeScale;
        }

        //Effect Menu Code

        if(isMenuOpen){
            if(Mathf.Abs(Input.GetAxis("MoveWeaponHorizontal")) > 0.1f || Mathf.Abs(Input.GetAxis("MoveWeaponVertical")) > 0.1f){
                Vector2 joystickPosition = new Vector2(Input.GetAxis("MoveWeaponHorizontal"), Input.GetAxis("MoveWeaponVertical"));
                
                float angle = Vector2.Angle(joystickPosition, new Vector2(1f, 0f));

                if(Input.GetAxis("MoveWeaponVertical") > 0f){
                    if(angle > 45f && angle < 135f && effectChosen != 2){
                        effectChosen = 2;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                    if(angle < 45f && effectChosen != 0){
                        effectChosen = 0;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                    if(angle > 135f && effectChosen != 1){
                        effectChosen = 1;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                }else{
                    if(angle > 45f && angle < 135f && effectChosen != 3){
                        effectChosen = 3;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                    if(angle < 45f && effectChosen != 0){
                        effectChosen = 0;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                    if(angle > 135f && effectChosen != 1){
                        effectChosen = 1;
                        clearEffectChoice();
                        effectButtons[effectChosen].GetComponent<Image>().color = new Color (0.1f,0.1f,0.1f,1f);
                    }
                }
            }

            for(int i = 0; i < effectButtons.Length; i++){
                if(effectButtons[i].GetComponent<RectTransform>().localScale.x > 1f && i != effectChosen){
                    effectButtons[i].GetComponent<RectTransform>().localScale -= new Vector3(0.01f,0.01f,0f);
                }
            }

            if(effectChosen != -1){
                if(effectButtons[effectChosen].GetComponent<RectTransform>().localScale.x < 1.1f){
                    effectButtons[effectChosen].GetComponent<RectTransform>().localScale += new Vector3(0.01f,0.01f,0f);
                }
            }
        }

        if(effectCooldown.localScale.y > 0f){
            effectCooldown.localScale -= new Vector3(0f, Time.fixedDeltaTime/effectCooldownTime, 0f);
        }else if(playerEffectActive){
            effectIcon.sprite = effectIconHolder;
            playerEffectActive = false;
            effectIcon.color = playerColor;
        }

        if(aoeCooldown.localScale.y > 0f){
            aoeCooldown.localScale -= new Vector3(0f, Time.fixedDeltaTime/aoeCooldownTime, 0f);
        }

        if(effectCooldownNPC.localScale.y > 0f){
            effectCooldownNPC.localScale -= new Vector3(0f, Time.fixedDeltaTime/effectCooldownNPCTime, 0f);
        }else if(npcEffectActive){
            effectIconNPC.sprite = effectIconHolder;
            npcEffectActive = false;
            effectIconNPC.color = npcColor;
        }

        if(aoeCooldownNPC.localScale.y > 0f){
            aoeCooldownNPC.localScale -= new Vector3(0f, Time.fixedDeltaTime/aoeCooldownNPCTime, 0f);
        }
    }

    void DisplayTime(float timeToDisplay)
    {
        if(time != null)
            time.sizeDelta = new Vector2(timeMaskSize / 180f * timeSeconds, time.sizeDelta.y);
        if(timeSprite != null){
            Color tmp = timeSprite.gameObject.GetComponent<Image>().color;
            tmp.r -= colorDelta[0];
            tmp.g -= colorDelta[1];
            tmp.b -= colorDelta[2];
            timeSprite.gameObject.GetComponent<Image>().color = tmp;
        }
    }

    public void addToCombo(bool positive){
        if(positive){
            if(gainScore){
                isActiveCombo = true;
                activeCombo = comboTimer;
                comboMultiplier += 1;
            }
        }
        else
        {
            isActiveCombo = false;
            scoreFloat -= (comboMultiplier > 0) ? 10f * comboMultiplier : 10f;
            StartCoroutine(startLoseScoreAnimation((comboMultiplier > 1) ? 2 + 2 * comboMultiplier : 2));
            activeCombo = 0f;
            comboMultiplier = 0;
            comboText.color = new Color(0f, 0f, 0f, 0f);
            scoreFloat = Mathf.Max(0f, scoreFloat);
            this.score.text = Mathf.CeilToInt(scoreFloat).ToString();
            for(int i = 0; i < orangeStars.Length; i++){
                orangeStars[i].SetActive(false);
                blueStars[i].SetActive(false);
            }
        }
        if (comboMultiplier > 1)
        {
            comboText.text = comboMultiplier.ToString() + "x Combo";
            comboText.fontSize = 24f + (comboMultiplier / 2f);
            comboText.color = colors[0];
            comboText.rectTransform.rotation = Quaternion.Euler(0f, 0f, Random.Range(-5f, 5f));
        }
        this.comboText.fontSize = fontSize + comboMultiplier*0.75f;
        if(comboMultiplier <= 45 && orangeStars.Length != 0 && blueStars.Length != 0){
            print((comboMultiplier/5)*2);
            orangeStars[(comboMultiplier/5)*2].SetActive(true);
            orangeStars[(comboMultiplier/5)*2+1].SetActive(true);
            blueStars[(comboMultiplier/5)*2].SetActive(true);
            blueStars[(comboMultiplier/5)*2+1].SetActive(true);
        }
    }

    public void changeScore(float score, bool isOrange)
    {
        if(gainScore){
            this.score.fontSize = 86f;
            scoreFloat += (comboMultiplier > 0) ? score * comboMultiplier : score;
            this.score.text = Mathf.CeilToInt(scoreFloat).ToString();
            if(isOrange){
                orangeUniverse.localScale = new Vector2(1.1f,1.1f);
            }else{
                blueUniverse.localScale = new Vector2(1.1f,1.1f);
            }
        }
        //progressBar.sizeDelta = new Vector2(progressBar.sizeDelta.x + score, progressBar.sizeDelta.y);
    }

    internal void openMenu()
    {
        AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
        audio.decreaseGamePitch();
        for(int i = 0; i < effectButtons.Length; i++){
            effectButtons[i].SetActive(true);
        }
        isMenuOpen = true;
    }

    internal void closeMenu()
    {
        AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
        audio.increaseGamePitch();
        if(effectChosen != -1){
            effectIcon.sprite = effectIcons[effectChosen].sprite;
            effectIcon.color = white;
            try{
            storage.addBuffToPlayer(secondsInt, effectChosen, scoreFloat, comboMultiplier);
            }catch(System.Exception e){
                Debug.Log(e.Message);
            }
        }
        clearEffectChoice();
        for(int i = 0; i < effectButtons.Length; i++){
            effectButtons[i].SetActive(false);
        }
        isMenuOpen = false;
        effectChosen = -1;
    }

    void clearEffectChoice(){
        for(int i = 0; i < effectButtons.Length; i++){
            effectButtons[i].GetComponent<Image>().color = new Color (0f,0f,0f,1f);
        }
    }

    internal int getEffectChosen()
    {
        return effectChosen;
    }

    public void returnToMenu(){
        storage.saveScore(scoreFloat, comboMultiplier);
        storage.saveInfo();
        AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
        audio.playMenuMusic();

        //Add code to store info
        SceneManager.LoadScene("MainMenu", LoadSceneMode.Single);
    }

    public void setNPCEffectIcon(int effectChosen){
            effectIconNPC.sprite = effectIcons[effectChosen].sprite;
            effectIconNPC.color = white;
            storage.addBuffToNPC(secondsInt, effectChosen, scoreFloat, comboMultiplier);
    }

    public void setEffectCooldown(float cooldown){
        effectCooldownTime = cooldown;
        effectCooldown.localScale = new Vector3(1f,1f,1f);
        playerEffectActive = true;
        StartCoroutine(makeButtonAnimation(0));
    }

    public void setAoeCooldown(float cooldown){
        aoeCooldownTime = cooldown;
        aoeCooldown.localScale = new Vector3(1f,1f,1f);
        StartCoroutine(makeButtonAnimation(1));
        storage.addSecondaryAttackToPlayer(secondsInt, scoreFloat, comboMultiplier);
    }

    public void setEffectNPCCooldown(float cooldown){
        effectCooldownNPCTime = cooldown;
        effectCooldownNPC.localScale = new Vector3(1f,1f,1f);
        npcEffectActive = true;
        StartCoroutine(makeButtonAnimation(2));
    }

    public void setAoeNPCCooldown(float cooldown){
        aoeCooldownNPCTime = cooldown;
        aoeCooldownNPC.localScale = new Vector3(1f,1f,1f);
        StartCoroutine(makeButtonAnimation(3));
        storage.addSecondaryAttackToNPC(secondsInt, scoreFloat, comboMultiplier);
    }

    public float getTimeScale()
    {
        return timeScale;
    }

    public void setScoreUnable(bool able, int who = -1){
        gainScore = able;
        if(gainScore){
            scoreUnable.text = "";
        }else{
            scoreUnable.text = "X";
        }

        if(who == 0){
            storage.addDeathToPlayer(secondsInt, scoreFloat, comboMultiplier);
        }else if(who == 1){
            storage.addDeathToNPC(secondsInt, scoreFloat, comboMultiplier);
        }
    }

    IEnumerator fadeMinuteFrame(int index){
        Image frame = minuteFrames[index].GetComponent<Image>();
        Color tmp = frame.color;
        tmp.a /= 2;
        frame.color = tmp;
        yield return null;
    }

    IEnumerator makeButtonAnimation(int index)
    {
        RectTransform transformButton = interfaceButtons[index].GetComponent<RectTransform>();
        yield return new WaitForFixedUpdate();
        transformButton.localScale = new Vector3(1.25f, 1.25f, 1f);
        float x = 1.25f;
        yield return new WaitForFixedUpdate();
        float downFloat = 0.005f;
        yield return new WaitForFixedUpdate();
        while (x > 1f)
        {
            transformButton.localScale -= new Vector3(downFloat, downFloat, 0f);
            x -= downFloat;
            yield return new WaitForFixedUpdate();
        }
        yield return null;
    }

    IEnumerator startLoseScoreAnimation(int objects){
        for(int i = 0; i < objects; i++){
            GameObject bar = Instantiate(lifePrefab, scorePosition.transform.position, Quaternion.identity);
            bar.GetComponent<loseScoreAnimation>().setScoreposition(scorePosition);
        }
        yield return null;
    }

    internal void saveKill(bool isPlayerEnemy)
    {
        storage.saveKill(secondsInt, scoreFloat, comboMultiplier, isPlayerEnemy);
    }

    internal void saveHit(bool isPlayerEnemy)
    {
        storage.saveHit(secondsInt, scoreFloat, comboMultiplier, isPlayerEnemy);
    }

    internal void saveMissPlayer()
    {
        storage.saveMissPlayer(secondsInt, scoreFloat, comboMultiplier);
    }

    internal void saveMissNPC()
    {
        storage.saveMissNPC(secondsInt, scoreFloat, comboMultiplier);
    }

    /*
        IEnumerator fadeMinuteFrame(int index){
            Image frame = minuteFrames[index].GetComponent<Image>();
            Color tmp = frame.color;
            while(minuteFrames[index].transform.localScale.x < 1f){
                minuteFrames[index].transform.localScale += new Vector3(0.005f, 0.005f, 0f);
                tmp.a -= 1f/50f;
                minuteFrames[index].GetComponent<Image>().color = tmp;
                yield return new WaitForFixedUpdate();
            }
            yield return null;
        }*/
}