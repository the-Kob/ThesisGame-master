using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;

public class npcButtonsBehavior : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{

    [SerializeField] string hoverText;
    [SerializeField] int type;
    [SerializeField] TMPro.TextMeshProUGUI infoText;

    public void OnPointerEnter(PointerEventData eventData)
    {
        infoText.text = hoverText;
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        infoText.text = "";
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
