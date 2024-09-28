using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class EventManager
{
    public static string[] effects = {"BUFF", "NERF", "SEC_ATTACK", "DEATH", "FINAL", "HIT", "HIT_KILL", "MISS"};
    public static string[] agents = {"PLAYER", "COMPANION", "PLAYER_ENEMY", "COMPANION_ENEMY"};

    public static Dictionary<string,string> addBuffToPlayer(int second, int effect, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        if(effect%2 == 0){
            entry["event_Type"] = effects[0];
        }else{
            entry["event_Type"] = effects[1];
        }
        entry["event_Actuator"] = agents[0];
        if(effect < 2){
            entry["event_Receiver"] = agents[3];
        }else{
            entry["event_Receiver"] = agents[2];
        }
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> addBuffToNPC(int second, int effect, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        if(effect%2 == 0){
            entry["event_Type"] = effects[0];
        }else{
            entry["event_Type"] = effects[1];
        }
        entry["event_Actuator"] = agents[1];
        if(effect < 2){
            entry["event_Receiver"] = agents[3];
        }else{
            entry["event_Receiver"] = agents[2];
        }
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> addDeathToPlayer(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[3];
        entry["event_Actuator"] = agents[2];
        entry["event_Receiver"] = agents[0];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> addDeathToNPC(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[3];
        entry["event_Actuator"] = agents[3];
        entry["event_Receiver"] = agents[1];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> addSecondaryAttackToPlayer(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[2];
        entry["event_Actuator"] = agents[0];
        entry["event_Receiver"] = agents[2];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> addSecondaryAttackToNPC(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[2];
        entry["event_Actuator"] = agents[1];
        entry["event_Receiver"] = agents[3];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    public static Dictionary<string,string> saveScore(int score, int studyId, int typeOfNPC, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[4];
        entry["event_Actuator"] = "-";
        entry["event_Receiver"] = "-";
        entry["time_Seconds"] = "180";
        return entry;
    }

    internal static Dictionary<string, string> saveKill(int second, int studyId, int typeOfNPC, int score, int combo, bool isPlayerEnemy)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[6];
        if(isPlayerEnemy){
            entry["event_Actuator"] = agents[0];
            entry["event_Receiver"] = agents[2];
        }else{
            entry["event_Actuator"] = agents[1];
            entry["event_Receiver"] = agents[3];
        }
        
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    internal static Dictionary<string, string> saveHit(int second, int studyId, int typeOfNPC, int score, int combo, bool isPlayerEnemy)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[5];

        if(isPlayerEnemy){
            entry["event_Actuator"] = agents[0];
            entry["event_Receiver"] = agents[2];
        }else{
            entry["event_Actuator"] = agents[1];
            entry["event_Receiver"] = agents[3];
        }
        
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    private static Dictionary<string, string> fillGenericInfo(Dictionary<string, string> entry, int studyId, int typeOfNPC, int score, int combo)
    {
        entry["study_ID"] = studyId.ToString();
        entry["companion_Type"] = typeOfNPC.ToString();
        entry["score"] = score.ToString();
        entry["combo"] = combo.ToString();
        return entry;
    }

    internal static Dictionary<string, string> saveMissPlayer(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[7];
        entry["event_Actuator"] = agents[0];
        entry["event_Receiver"] = agents[2];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }

    internal static Dictionary<string, string> saveMissNPC(int second, int studyId, int typeOfNPC, int score, int combo)
    {
        Dictionary<string,string> entry = new Dictionary<string, string>();
        entry = fillGenericInfo(entry, studyId, typeOfNPC, score, combo);
        entry["event_Type"] = effects[7];
        entry["event_Actuator"] = agents[1];
        entry["event_Receiver"] = agents[3];
        entry["time_Seconds"] = second.ToString();
        return entry;
    }
}
