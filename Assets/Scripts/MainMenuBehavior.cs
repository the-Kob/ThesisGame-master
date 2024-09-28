using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainMenuBehavior : MonoBehaviour
{

    [SerializeField]
    Tuple<int, string> info;

    [SerializeField]
    GameObject TutorialMenu;
    [SerializeField]
    GameObject SettingsMenu;

    [SerializeField]
    GameObject PlayButton;
    [SerializeField]
    GameObject SettingsButton;

    bool joystickPressed;
    [SerializeField]
    GameObject[] mainMenuButtons;
    int menuSelected; //{0-Main} {1-NPCButtons} {2-Settings}
    int buttonSelected;

    [SerializeField]
    GameObject[] npcButtons;
    GameObject[] npcButtonsStatik = new GameObject[6];
    Vector3[] npcButtonsPositions = new Vector3[4];
    List<int> listOfDisabled = new List<int>();
    List<string> listOfDisabledStrings;

    Storage storage;

    // Start is called before the first frame update
    void Start()
    {
        for(int i = 0; i < npcButtons.Length; i++){
            npcButtonsStatik[i] = npcButtons[i];
        }

        storage = GameObject.Find("Storage").GetComponent<Storage>();
        SettingsMenu.SetActive(false);

        for(int i = 1; i < 5; i++)
        {
            npcButtonsPositions[i-1] = npcButtons[i].transform.position;
        }

        int choice = 0;

        if(storage.alreadyChose){
            choice = storage.choiceInt;
        }else{
            storage.alreadyChose = true;
            choice = UnityEngine.Random.Range(0, 4);
            storage.choiceInt = choice;
        }

        for(int i = 1; i < 5; i++)
        {
            npcButtons[1 + (i + choice) % 4].transform.position = npcButtonsPositions[i-1];
            npcButtonsStatik[i] = npcButtons[1 + (i + choice) % 4];
        }

        TutorialMenu.SetActive(false);

        listOfDisabledStrings = storage.getDisabledButtons();

        foreach(string g in listOfDisabledStrings){
            for(int i = 0; i < npcButtonsStatik.Length; i++){
                if(g == npcButtonsStatik[i].name){
                    Debug.Log(i);
                    listOfDisabled.Add(i);
                }
            }
        }

        if(!listOfDisabled.Contains(0)){
            for(int i = 1; i < 5; i++)
            {
                npcButtons[i].GetComponent<Button>().interactable = false;
                listOfDisabled.Add(i);
            }
        }

        foreach(int n in listOfDisabled){
            npcButtonsStatik[n].GetComponent<Button>().interactable = false;
        }

        foreach(GameObject i in npcButtonsStatik){
            Debug.Log(i.name);
        }

        mainMenuButtons[0].GetComponent<Button>().Select();
        menuSelected = 0;
    }

    private void Update() {
        
        if(Input.GetAxis("Vertical") > 0.2f && !joystickPressed){
            joystickPressed = true;
            if(menuSelected == 0){
                buttonSelected = 0;
                mainMenuButtons[buttonSelected].GetComponent<Button>().Select();
            }else if(menuSelected == 1){
                if(buttonSelected == 5){
                    for(int i = 4; i > -1; i--){
                        if(!listOfDisabled.Contains(i)){
                            buttonSelected = i;
                            break;
                        } 
                    }
                }else if(buttonSelected == 4){
                    if(!listOfDisabled.Contains(2)){
                        buttonSelected = 2;
                    }else if(!listOfDisabled.Contains(1)){
                        buttonSelected = 1;
                    }
                }else if(buttonSelected == 3){
                    if(!listOfDisabled.Contains(1)){
                        buttonSelected = 1;
                    }else if(!listOfDisabled.Contains(2)){
                        buttonSelected = 2;
                    }
                }
                npcButtonsStatik[buttonSelected].GetComponent<Button>().Select();
            }
        }else if(Input.GetAxis("Vertical") < -0.2f && !joystickPressed){
            joystickPressed = true;
            if(menuSelected == 0){
                buttonSelected = 1;
                mainMenuButtons[buttonSelected].GetComponent<Button>().Select();
            }else if(menuSelected == 1){
                if(buttonSelected == 0){
                    for(int i = 1; i < 6; i++){
                        if(!listOfDisabled.Contains(i)){
                            buttonSelected = i;
                        } 
                    }
                }else if(buttonSelected == 1){
                    if(listOfDisabled.Contains(3)){
                        buttonSelected = 4;
                    }else{
                        buttonSelected = 3;
                    }
                }else if(buttonSelected == 2){
                    if(listOfDisabled.Contains(4)){
                        buttonSelected = 3;
                    }else{
                        buttonSelected = 4;
                    }
                }else if(buttonSelected == 3){
                    buttonSelected = 5;
                }else if(buttonSelected == 4){
                    buttonSelected = 5;
                }
                    npcButtonsStatik[buttonSelected].GetComponent<Button>().Select();
            }
        }else if(Input.GetAxis("Horizontal") > 0.2f && !joystickPressed){
            if(menuSelected == 1){
                if(buttonSelected == 1){
                    if(!listOfDisabled.Contains(2)){
                        buttonSelected = 2;
                    }else if(!listOfDisabled.Contains(4)){
                        buttonSelected = 4;
                    }
                }else if(buttonSelected == 3){
                    if(!listOfDisabled.Contains(4)){
                        buttonSelected = 4;
                    }else if(!listOfDisabled.Contains(2)){
                        buttonSelected = 2;
                    }
                }
                npcButtonsStatik[buttonSelected].GetComponent<Button>().Select();
            }
        }else if(Input.GetAxis("Horizontal") < -0.2f && !joystickPressed){
            if(menuSelected == 1){
                if(buttonSelected == 2){
                    if(!listOfDisabled.Contains(1)){
                        buttonSelected = 1;
                    }else if(!listOfDisabled.Contains(3)){
                        buttonSelected = 3;
                    }
                }else if(buttonSelected == 4){
                    if(!listOfDisabled.Contains(3)){
                        buttonSelected = 3;
                    }else if(!listOfDisabled.Contains(1)){
                        buttonSelected = 1;
                    }
                }
                npcButtonsStatik[buttonSelected].GetComponent<Button>().Select();
            }
        }

        //Debug.Log("Selected: " + buttonSelected);

        if(Math.Abs(Input.GetAxis("Horizontal")) < 0.2f && Math.Abs(Input.GetAxis("Vertical")) < 0.2f){
            joystickPressed = false;
        }

        if(Input.GetButtonDown("Select")){
            if(menuSelected == 0){
                mainMenuButtons[buttonSelected].GetComponent<Button>().onClick.Invoke();
                menuSelected = 1;
                if(!listOfDisabled.Contains(0))
                    buttonSelected = 0;
                else
                    buttonSelected = 5;
                npcButtonsStatik[buttonSelected].GetComponent<Button>().Select();
            }
            else if(menuSelected == 1){
                npcButtonsStatik[buttonSelected].GetComponent<Button>().onClick.Invoke();
                buttonSelected = 0;
            }
        }

        //PlayButton.GetComponent<Button>().onClick.Invoke();
        //PlayButton.GetComponent<Button>().Select();
    }

    public void setTypeOfNPC(int type)
    {
        AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
        audio.playGameMusic();
        storage.setTutorialFlag(false);
        storage.setTypeOfNPC(type);
        storage.addButtonToDisable(npcButtons[type + 1].name);
        SceneManager.LoadScene("Gameplay", LoadSceneMode.Single);
    }

    public void Play(){
        PlayButton.SetActive(false);
        TutorialMenu.SetActive(true);
        SettingsMenu.SetActive(false);
        SettingsButton.SetActive(false);
    }

    public void Back(){
        PlayButton.SetActive(true);
        SettingsButton.SetActive(true);
        TutorialMenu.SetActive(false);
        SettingsMenu.SetActive(false);
        menuSelected = 0;
        mainMenuButtons[0].GetComponent<Button>().Select();
    }

    public void Settings(){
        PlayButton.SetActive(false);
        SettingsButton.SetActive(false);
        TutorialMenu.SetActive(false);
        SettingsMenu.SetActive(true);
    }

    public void LoadTutorial(){
        AudioManagerScript audio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioManagerScript>();
        audio.stopMusic();
        storage.setTutorialFlag(true);
        storage.cleanList();
        storage.addButtonToDisable(npcButtons[0].name);
        SceneManager.LoadScene("Tutorial", LoadSceneMode.Single);
    }
}