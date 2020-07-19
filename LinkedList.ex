defmodule LinkedList do
  def new(name) do
    :ets.new(name, [:set, :protected, :named_table])
    {name, nil, nil}
  end

  def put({name, nil, nil}, key, value) do
    :ets.insert(name, {key, nil, value, nil})
    {name, key, key}
  end

  def put({name, head, tail}, key, value) do
    :ets.insert(name, {key, tail, value, nil})

    prev = :ets.lookup(name, tail)
    [{ a, b, c, d }] = prev
    :ets.insert(name, {a, b, c, key})
    new_tail = key

    {name, head, new_tail}
  end

  # del head
  def del({name, key, tail}, key) do
    record = :ets.lookup(name, key)
    [{ _a, _b, _c, next }] = record
    :ets.delete(name, key)
    {name, next, tail}
  end

  # only 1 entry
  def del({name, key, key}, key) do
    :ets.delete(name, key)
    {name, nil, nil}
  end

  # del tail
  def del({name, head, key}, key) do
    record = :ets.lookup(name, key)
    [{ prev, _b, _c, _d }] = record
    :ets.delete(name, key)
    {name, head, prev}
  end

  # del middle
  def del({name, head, tail}, key) do
    # delete record
    record = :ets.lookup(name, key)
    [{ _a, prev, _c, next }] = record
    :ets.delete(name, key)

    # set previous record to next
    prev_record = :ets.lookup(name, prev)
    [{ a, b, c, d }] = prev_record
    :ets.insert(name, {a, b, c, next})

    # set next record to previous
    next_record = :ets.lookup(name, next)
    [{ a, b, c, d }] = next_record
    :ets.insert(name, {a, b, c, prev})

    {name, head, tail}
  end

  def get({name, _head, _tail}, key) do
    [{ _, _, data, _ }] = :ets.lookup(name, key)
    data
  end
end
