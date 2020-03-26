import cleanup


class Result:
    def __init__(self, passed, err_msg=None):
        self.err_msg = err_msg
        self.passed = passed


def run_tests(df):
    test_results = [
        test_cluster_list_time(df),
        test_project_list_time(df),
    ]
    passed = True
    err_msgs = []
    for result in test_results:
        if not result.passed:
            passed = False
            err_msgs.append(result.err_msg)
    if not passed:
        print(len(err_msgs), "metric tests FAILED:\n")
        errors = "\n".join(err_msgs)
        cleanup.run()
        raise Exception(errors)
    else:
        print("All metric tests passed!")


def test_cluster_list_time(df):
    try:
        average_less_than(df, "rancher_cluster_list_time", 5)
    except AssertionError as e:
        return Result(False, err_msg="rancher cluster list time not less than 5 seconds.")
    return Result(True)


def test_project_list_time(df):
    try:
        average_less_than(df, "rancher_project_list_time", 5)
    except AssertionError as e:
        return Result(False, err_msg="rancher project list time not less than 5 seconds.")
    return Result(True)


def average_less_than(df, col, limit):
    averages = df.mean("rows")

    assert averages[col] < limit


