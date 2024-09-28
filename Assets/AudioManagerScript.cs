using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManagerScript : MonoBehaviour
{

    [SerializeField] AudioSource playerShot;
    [SerializeField] AudioSource npcShot;
    [SerializeField] AudioSource music;

    [SerializeField] AudioClip[] musics;
    [SerializeField] AudioClip[] shots;

    void Awake()
    {
        GameObject[] objs = GameObject.FindGameObjectsWithTag("AudioManager");

        if (objs.Length > 1)
        {
            Destroy(this.gameObject);
        }

        DontDestroyOnLoad(this.gameObject);
    }

    void Start()
    {
        AudioSource[] audios = gameObject.GetComponents<AudioSource>();
        playerShot = audios[0];
        npcShot = audios[1];
        music = audios[2];
    }

    public void playBulletSound(){
        playerShot.clip = shots[Random.Range(0,6)];
        playerShot.Play();
    }

    public void playNpcBulletSound(){
        npcShot.clip = shots[Random.Range(0,6)];
        npcShot.Play();
    }

    public void playGameMusic(){
        music.clip = musics[1];
        music.Play();
    }

    public void decreaseGamePitch(){
        playerShot.pitch -= 0.25f;
        npcShot.pitch -= 0.25f;
        music.pitch -= 0.25f;
    }

    public void increaseGamePitch(){
        playerShot.pitch += 0.25f;
        npcShot.pitch += 0.25f;
        music.pitch += 0.25f;
    }

    public void playMenuMusic(){
        music.clip = musics[0];
        music.Play();
    }

    public void stopMusic(){
        music.Stop();
    }
    
}
