using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Newtonsoft.Json;

public class InputHandler : MonoBehaviour {

    [SerializeField] string filenameJSON;
    [SerializeField] string filenameCSV;
    List<InputEntry> entries = new List<InputEntry> ();

    private void Awake () {
        entries = FileHandler.ReadListFromJSON<InputEntry> (filenameJSON);
    }

    public void AddNameToList () {
        FileHandler.SaveToJSON<InputEntry> (entries, filenameJSON);
    }

    public List<InputEntry> getEntries(){
        return entries;
    }

    public string getFilename(){
        return filenameJSON;
    }
}