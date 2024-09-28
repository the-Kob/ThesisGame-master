using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveManager : MonoBehaviour
{

    [SerializeField] Transform player;
    [SerializeField] GameObject playerEnemy;
    [SerializeField] GameObject npcEnemy;
    int waveNumber = 0;
    IEnumerator coroutine;

    void Start()
    {
        Random.InitState(42);
    }

    public void startWave()
    {
        waveNumber += 1;
        coroutine = spawnWave(waveNumber);
        StartCoroutine(coroutine);
    }

    private IEnumerator spawnWave(int number)
    { 
        int enemies = number * 3 + 7;
        Vector3 playerEnemyOffset = Vector3.zero;
        Vector3 npcEnemyOffset = Vector3.zero;

        for (int i = 0; i < enemies; i++)
        {
            Vector3 playerDirection = new Vector3(Input.GetAxis("Horizontal"),Input.GetAxis("Vertical"),0f).normalized*10f;
            if(playerDirection.magnitude > 1f){
                playerEnemyOffset = Quaternion.Euler(0, 0, Random.Range(-45, 45)) * playerDirection;
            }else{
                playerEnemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(10f, 15f), Random.Range(10f, 15f), 0);
            }
            npcEnemyOffset = Quaternion.Euler(0, 0, Random.Range(0, 360)) * new Vector3(Random.Range(10f, 15f), Random.Range(10f, 15f), 0);
            Instantiate(playerEnemy, player.position + playerEnemyOffset, Quaternion.Euler(0, 0, 0));
            Instantiate(npcEnemy, player.position + npcEnemyOffset, Quaternion.Euler(0, 0, 0));
            yield return new WaitForSeconds(25f/enemies);
        }

        yield return null;
    }
}
