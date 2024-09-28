using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarsMovementScript : MonoBehaviour
{
    [SerializeField]
    private bool isOrange;
    private bool isEnabled = true;
    RectTransform rectPos;
    float epsilon;

    [SerializeField]
    private float speed;
    // Start is called before the first frame update
    void Start()
    {
        rectPos = this.gameObject.GetComponent<RectTransform>();
        Random.InitState(42);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(isOrange){
            rectPos.anchoredPosition += new Vector2(0.08f + speed,0f);
            if(rectPos.anchoredPosition.x >= 0 + 591f/2f){
                rectPos.anchoredPosition = -new Vector2(855f, 0f);
            }
        }else{
            rectPos.anchoredPosition -= new Vector2(0.08f + speed,0f);
            if(rectPos.anchoredPosition.x <= 0 - 591f/2f){
                rectPos.anchoredPosition = new Vector2(855f, 0f);
            }
        }
    }

    private void OnEnable() {
        epsilon = Random.Range(-115f,115f);
        rectPos = this.gameObject.GetComponent<RectTransform>();
        rectPos.anchoredPosition = new Vector2(rectPos.anchoredPosition.x,epsilon);
    }
}