using System;
using System.Collections.Generic;
using UnityEngine;
using Newtonsoft.Json;

[Serializable]
public class InputEntry {

    public int studyId;
    public int score;
    public List<(int,int)> buffsUsedByPlayer;
    public List<(int,int)> buffsUsedByNPC;
    public List<int> secondaryAttackByPlayer;
    public List<int> secondaryAttackByNPC;
    public List<int> deathsByPlayer;
    public List<int> deathsByNPC;
    

    public InputEntry (int id) {
        buffsUsedByPlayer = new List<(int,int)>();
        buffsUsedByNPC = new List<(int,int)>();
        deathsByPlayer = new List<int>();
        deathsByNPC = new List<int>();
        secondaryAttackByPlayer = new List<int>();
        secondaryAttackByNPC = new List<int>();
        studyId = id;
    }

    public void writestuff(InputEntry entry){
        JsonConvert.SerializeObject(entry);
    }

    public void addBuffToPlayer(int second, int effect){
        buffsUsedByPlayer.Add((second,effect));
    }

    public void addBuffToNPC(int second, int effect){
        buffsUsedByNPC.Add((second,effect));
    }

    public void addDeathToPlayer(int second){
        deathsByPlayer.Add(second);
    }

    public void addDeathToNPC(int second){
        deathsByNPC.Add(second);
    }

    public void addSecondaryAttackToPlayer(int second){
        secondaryAttackByPlayer.Add(second);
    }

    public void addSecondaryAttackToNPC(int second){
        secondaryAttackByNPC.Add(second);
    }
}