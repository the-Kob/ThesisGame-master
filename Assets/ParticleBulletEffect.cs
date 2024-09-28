using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleBulletEffect : MonoBehaviour
{

    private float scalar = 1f;
    SpriteRenderer ball;

    // Start is called before the first frame update
    void Start()
    {
        ball = gameObject.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(scalar <= 0f){
            Destroy(this.gameObject);
        }else{
            transform.localScale = transform.localScale * scalar;
            scalar -= Time.fixedDeltaTime;
            Color tmp = ball.color;
            tmp.a = scalar;
            ball.color = tmp;
        }
    }
}
