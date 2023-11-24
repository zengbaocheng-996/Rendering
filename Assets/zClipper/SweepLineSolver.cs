using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace zClipper
{
    public class SweepLineSolver
    {
        private List<Vector2> _points;
        private float _step = 0.0001f;
        private float _xMin = Mathf.Infinity;
        private float _xMax = Mathf.NegativeInfinity;
        private int _count;
        public float xCurr;
        public SweepLineSolver(List<Vector2> points)
        {
            points.Sort((prev, next) =>
            {
                return prev.x.CompareTo(next.x);
            });
            _xMin = points[0].x;
            _xMax = points[points.Count - 1].x;
            _points = points;
            _count = points.Count;
        }
        public void Solve()
        {
            int index = 0;
            //Debug.Log(_xMin);
            //Debug.Log(_xMax);\

            for (float xCurr = _xMin; xCurr <= _xMax; xCurr += _step)
            {
                this.xCurr = xCurr;
                //Debug.LogWarning(xCurr);
                //Debug.LogError(Mathf.Abs(xCurr - _points[index].x));
                if (Mathf.Abs(xCurr - _points[index].x) < _step)
                {                    
                    //Debug.LogError("Find New Point");
                    Debug.LogErrorFormat("SweepEvent -> Point {0}", _points[index]);
                    index += 1;
                }
                if(index > _count - 1)
                {
                    break;
                }
            }
        }
    }
}

