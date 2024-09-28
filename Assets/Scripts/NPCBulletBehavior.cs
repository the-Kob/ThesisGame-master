using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPCBulletBehavior : MonoBehaviour
{
    [SerializeField] float speed = 1f;
    private float damage = 5f;
    private bool hitSomeone = false;
    private float impactStrength = 0.4f;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.position += transform.right * Time.deltaTime * speed;
    }

    void OnTriggerEnter2D(Collider2D col)
    {
        if (col.gameObject.tag == "NPCEnemy" && !hitSomeone)
        {
            hitSomeone = true;
            col.gameObject.GetComponent<EnemyBehavior>().receiveDamage(damage, transform.right, impactStrength * 50f);
            Destroy(gameObject);
        }
    }
}
