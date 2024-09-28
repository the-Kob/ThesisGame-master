using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Newtonsoft.Json;
using System.Xml.Serialization;

public class Storage : MonoBehaviour
{

    bool isTutorial;
    int typeOfNPC;
    [SerializeField] List<string> disabledButtons;
    public bool alreadyChose;
    public int choiceInt;
    List<InputEntry> entries;
    int studyId;
    InputEntry currentEntry;
    string filename;
    FileLogManager fileManager = new FileLogManager();

    void Awake()
    {
        GameObject[] objs = GameObject.FindGameObjectsWithTag("Storage");

        if (objs.Length > 1)
        {
            Destroy(this.gameObject);
        }

        DontDestroyOnLoad(this.gameObject);
    }

    // Start is called before the first frame update
    void Start()
    {
        typeOfNPC = Random.Range(0, 4);
        filename = this.gameObject.GetComponent<InputHandler>().getFilename();
        entries = this.gameObject.GetComponent<InputHandler>().getEntries();
        if(entries.Count == 0){
            studyId = 0;
        }else{
            studyId = entries[entries.Count-1].studyId + 1;
        }
    }

    public void setTutorialFlag(bool isIt){
        isTutorial = isIt;
    }

    public void setTypeOfNPC(int type)
    {
        Debug.Log(type);
        typeOfNPC = type;

        currentEntry = new InputEntry(studyId);
    }

    public int getTypeOfNPC()
    {
        return typeOfNPC;
    }

    public List<string> getDisabledButtons(){
        return disabledButtons;
    }

    public void addButtonToDisable(string btn){
        disabledButtons.Add(btn);
    }

    public void cleanList(){
        disabledButtons.Clear();
    }

    internal void saveInfo()
    {
        if(!isTutorial){
            entries.Add(currentEntry);
            FileHandler.SaveToJSON<InputEntry>(entries, filename);
            currentEntry = null;
        }
    }

    internal void saveScore(float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.score = (int) scoreFloat;
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.saveScore((int) scoreFloat, studyId, typeOfNPC, combo), false));
            }
        }
    }

    public void addBuffToPlayer(int second, int effect, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addBuffToPlayer(second, effect);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addBuffToPlayer(second, effect, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    public void addBuffToNPC(int second, int effect, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addBuffToNPC(second, effect);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addBuffToNPC(second, effect, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    public void addDeathToPlayer(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addDeathToPlayer(second);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addDeathToPlayer(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    public void addDeathToNPC(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addDeathToNPC(second);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addDeathToNPC(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    public void addSecondaryAttackToPlayer(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addSecondaryAttackToPlayer(second);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addSecondaryAttackToPlayer(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    public void addSecondaryAttackToNPC(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            if(currentEntry != null){
                currentEntry.addSecondaryAttackToNPC(second);
                StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.addSecondaryAttackToNPC(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
            }
        }
    }

    internal void saveKill(int second, float scoreFloat, int combo, bool isPlayerEnemy)
    {
        if(!isTutorial){
            StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.saveKill(second, studyId, typeOfNPC, (int) scoreFloat, combo, isPlayerEnemy), false));
        }
    }

    internal void saveHit(int second, float scoreFloat, int combo, bool isPlayerEnemy)
    {
        if(!isTutorial){
            StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.saveHit(second, studyId, typeOfNPC, (int) scoreFloat, combo, isPlayerEnemy), false));
        }
    }

    internal void saveMissPlayer(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.saveMissPlayer(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
        }
    }

    internal void saveMissNPC(int second, float scoreFloat, int combo)
    {
        if(!isTutorial){
            StartCoroutine(fileManager.WriteToLog("EventsData", "Events", EventManager.saveMissNPC(second, studyId, typeOfNPC, (int) scoreFloat, combo), false));
        }
    }
}