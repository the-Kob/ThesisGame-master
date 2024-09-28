using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackgroundMover : MonoBehaviour
{

    public Transform playerPosition;
    private SpriteRenderer backgroundSprite;

    // Start is called before the first frame update
    void Start()
    {
        backgroundSprite = gameObject.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //Debug.Log(backgroundSprite.bounds.size.x);
        if (playerPosition.position.x - transform.position.x >= backgroundSprite.bounds.size.x *2f){
            transform.position = transform.position + new Vector3(3 * backgroundSprite.bounds.size.x, 0, 0);
        }else if (playerPosition.position.x - transform.position.x < -backgroundSprite.bounds.size.x *2f){
            transform.position = transform.position - new Vector3(3 * backgroundSprite.bounds.size.x, 0, 0);
        }

        if (playerPosition.position.y - transform.position.y >= backgroundSprite.bounds.size.y * 2f){
            transform.position = transform.position + new Vector3(0, 3 * backgroundSprite.bounds.size.y, 0);
        }else if (playerPosition.position.y - transform.position.y < -backgroundSprite.bounds.size.y *2f){
            transform.position = transform.position - new Vector3(0, 3 * backgroundSprite.bounds.size.y, 0);
        }
    }
}