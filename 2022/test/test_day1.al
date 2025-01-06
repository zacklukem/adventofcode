def input() = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"

def test_day1a() = {
    assert_eq(Day1a.run(input()), 24000)
}

def test_day1b() = {
    assert_eq(Day1b.run(input()), 45000)
}
