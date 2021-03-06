import { Reply, noMore } from "./reply";
import { endEvent, Event } from "./event";
import { EventSink } from "./types"
import { Desc } from "./describe"
import Observable from "./observable";

/** @hidden */
export function take<V>(count: number, src: Observable<V>, desc?: Desc): Observable<V> {
  return src.transform(takeT(count), desc || new Desc(src, "take", [count]))
}

/** @hidden */
export function takeT<V>(count: number): (e: Event<V>, sink: EventSink<V>) => Reply {
  return (e, sink) => {
    if (!e.hasValue) {
      return sink(e);
    } else {
      count--;
      if (count > 0) {
        return sink(e);
      } else {
        if (count === 0) { sink(e) }
        sink(endEvent());
        return noMore;
      }
    }
  }
}
